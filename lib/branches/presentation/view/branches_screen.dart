import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/core/widgets/caffe_app_bar.dart';
import 'package:gdg_campus_coffee/branches/presentation/mvvm/branches_view_model.dart';
import 'package:gdg_campus_coffee/branches/domain/entity/branch.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final BranchesViewModel _viewModel = BranchesViewModel();
  Completer<GoogleMapController> _controller = Completer();
  Branch? _selectedBranch;
  bool _hasCenteredInitially = false;
  final Map<String, BitmapDescriptor> _markerIcons = {};

  // "Caffè & Codex" Shadow Style (Pure Dark + Espresso Roads)
  static const String _darkMapStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#1a1008"}]},
    {"elementType": "labels.text.fill", "stylers": [{"color": "#5a4a38"}]},
    {"elementType": "labels.text.stroke", "stylers": [{"color": "#1a1008"}]},
    {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#9a8a74"}]},
    {"featureType": "poi", "stylers": [{"visibility": "off"}]},
    {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#2a1f10"}]},
    {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#1a1008"}]},
    {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#5a4a38"}]},
    {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#2a1f10"}]},
    {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#1a1008"}]},
    {"featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [{"color": "#9a8a74"}]},
    {"featureType": "road.arterial", "elementType": "geometry", "stylers": [{"color": "#2a1f10"}]},
    {"featureType": "transit", "stylers": [{"visibility": "off"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0d0a08"}]},
    {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#3a2a18"}]}
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  Future<void> _generateMarkers() async {
    for (var branch in _viewModel.branches) {
      if (branch.name != null) {
        final icon = await _createLabeledMarkerIcon(branch.name!, branch.name == _selectedBranch?.name);
        _markerIcons[branch.name!] = icon;
      }
    }
    if (mounted) setState(() {});
  }

  Future<BitmapDescriptor> _createLabeledMarkerIcon(String label, bool isSelected) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double width = 300.0;
    const double height = 150.0;

    final Color pinColor = isSelected ? AppColors.gold : const Color(0xFF8B7355);
    final Offset pinTip = const Offset(width / 2, height - 10);

    // 1. Draw Teardrop Pin Shape
    final Path pinPath = Path();
    pinPath.moveTo(pinTip.dx, pinTip.dy);
    // Left side of teardrop
    pinPath.cubicTo(
      pinTip.dx - 20, pinTip.dy - 20, 
      pinTip.dx - 25, pinTip.dy - 45, 
      pinTip.dx, pinTip.dy - 60
    );
    // Right side of teardrop
    pinPath.cubicTo(
      pinTip.dx + 25, pinTip.dy - 45, 
      pinTip.dx + 20, pinTip.dy - 20, 
      pinTip.dx, pinTip.dy
    );
    pinPath.close();

    // Shadow for pin
    canvas.drawPath(pinPath, Paint()..color = Colors.black.withValues(alpha: 0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    // Fill pin
    canvas.drawPath(pinPath, Paint()..color = pinColor);
    // Inner white circle for "pin" look
    canvas.drawCircle(Offset(pinTip.dx, pinTip.dy - 40), 8, Paint()..color = AppColors.bgDark);

    // 2. Draw Label Box
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: label.toUpperCase(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        fontFamily: 'Inter',
        letterSpacing: 1.5,
        shadows: [
          Shadow(color: Colors.black.withValues(alpha: 0.8), offset: const Offset(0, 2), blurRadius: 4),
        ],
      ),
    );

    textPainter.layout(minWidth: 0, maxWidth: width - 40);
    
    // Background for text (Sleek dark pill)
    final RRect rect = RRect.fromLTRBR(
      (width - textPainter.width) / 2 - 16,
      height - 115,
      (width + textPainter.width) / 2 + 16,
      height - 75,
      const Radius.circular(8),
    );
    
    // Shadow for label box
    canvas.drawRRect(rect, Paint()..color = Colors.black.withValues(alpha: 0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    // Fill label box
    canvas.drawRRect(rect, Paint()..color = Colors.black.withValues(alpha: 0.85));
    // Border for label box
    canvas.drawRRect(rect, Paint()..color = pinColor.withValues(alpha: 0.5)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    textPainter.paint(canvas, Offset((width - textPainter.width) / 2, height - 110));

    final ui.Image image = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _onViewModelChanged() {
    if (mounted && _viewModel.branches.isNotEmpty) {
      if (_markerIcons.isEmpty) {
        _generateMarkers();
      }
      setState(() {
        if (_selectedBranch == null || !_hasCenteredInitially) {
          _selectedBranch = _viewModel.branches.first;
          _centerOnBranch(_selectedBranch!);
          _hasCenteredInitially = true;
        }
      });
    }
  }

  Future<void> _centerOnBranch(Branch branch) async {
    final GoogleMapController controller = await _controller.future;
    if (branch.latitude != null && branch.longitude != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(branch.latitude!, branch.longitude!),
            zoom: 15.5,
          ),
        ),
      );
      setState(() {
        _selectedBranch = branch;
        _generateMarkers(); // Refresh markers to update selection glow
      });
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const CaffeAppBar(),
      body: _viewModel.loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : Stack(
              children: [
                // 1. Google Map Component
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: (_selectedBranch != null && _selectedBranch!.latitude != null && _selectedBranch!.longitude != null)
                          ? LatLng(_selectedBranch!.latitude!, _selectedBranch!.longitude!)
                          : const LatLng(37.0286961, 35.3048137), // Seytim Adana
                      zoom: 14.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(_darkMapStyle);
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                    markers: _viewModel.branches
                        .where((b) => b.latitude != null && b.longitude != null)
                        .map((branch) {
                      return Marker(
                        markerId: MarkerId(branch.name ?? '${branch.latitude}_${branch.longitude}'),
                        position: LatLng(branch.latitude!, branch.longitude!),
                        icon: _markerIcons[branch.name] ?? BitmapDescriptor.defaultMarker,
                        anchor: const Offset(0.5, 0.8),
                        onTap: () => _centerOnBranch(branch),
                      );
                    }).toSet(),
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),

                // 2. Floating Search Bar
                Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.bgDark.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: TextField(
                      style: AppFonts.inter(color: AppColors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search for roasteries or libraries...',
                        hintStyle: AppFonts.inter(color: AppColors.textMuted, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // 3. Draggable Scrollable Sheet (Bottom)
                if (_selectedBranch != null)
                  DraggableScrollableSheet(
                    initialChildSize: 0.42,
                    minChildSize: 0.42,
                    maxChildSize: 0.92,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF231A0E),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          border: Border.all(color: AppColors.border, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 30,
                              offset: const Offset(0, -10),
                            ),
                          ],
                        ),
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          children: [
                            // Drag Handle
                            Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.textMuted.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            
                            // Top Section: Currently Selected Info
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.gold.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'SELECTED ROASTERY',
                                          style: AppFonts.inter(
                                            color: AppColors.gold,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                                          const SizedBox(width: 4),
                                          Text(
                                            _selectedBranch!.rating?.toStringAsFixed(1) ?? '4.8',
                                            style: AppFonts.inter(
                                              color: AppColors.textPrimary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    _selectedBranch!.name ?? 'Unknown',
                                    style: AppFonts.playfairDisplay(
                                      color: AppColors.textPrimary,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_rounded, color: AppColors.gold, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_selectedBranch!.distance ?? '0.4 miles'} away',
                                        style: AppFonts.inter(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _selectedBranch!.description ?? '',
                                    style: AppFonts.inter(
                                      color: AppColors.textSecondary,
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Images
                                  if (_selectedBranch!.photos != null && _selectedBranch!.photos!.isNotEmpty)
                                    SizedBox(
                                      height: 120,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _selectedBranch!.photos!.length,
                                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                                        itemBuilder: (context, index) {
                                          final photo = _selectedBranch!.photos![index];
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: photo.startsWith('http') 
                                              ? Image.network(photo, width: 200, height: 120, fit: BoxFit.cover)
                                              : Image.asset(photo, width: 200, height: 120, fit: BoxFit.cover),
                                          );
                                        },
                                      ),
                                    ),
                                  const SizedBox(height: 28),
                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.assistant_direction_rounded, size: 20),
                                          label: const Text('Get Directions'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.gold,
                                            foregroundColor: AppColors.bgDark,
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            elevation: 0,
                                            textStyle: AppFonts.inter(fontWeight: FontWeight.w800, fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                                          label: const Text('Save Place'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.textPrimary,
                                            side: const BorderSide(color: AppColors.border, width: 1.5),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            textStyle: AppFonts.inter(fontWeight: FontWeight.w800, fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Bottom Section: List of Nearby Shops
                            Container(
                              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                              child: Text(
                                'NEARBY COFFEE SANCTUARIES',
                                style: AppFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Divider(color: AppColors.border, height: 1),
                            ),
                            ..._viewModel.branches.map((branch) => _BranchListItem(
                              branch: branch,
                              isSelected: _selectedBranch?.name == branch.name,
                              onTap: (b) => _centerOnBranch(b),
                            )),
                            const SizedBox(height: 60),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}

class _BranchListItem extends StatelessWidget {
  final Branch branch;
  final bool isSelected;
  final Function(Branch) onTap;

  const _BranchListItem({
    required this.branch,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(branch),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold.withValues(alpha: 0.08) : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.gold : AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.3), blurRadius: 10)] : null,
              ),
              child: Icon(
                Icons.coffee_rounded,
                color: isSelected ? AppColors.bgDark : AppColors.gold,
                size: 26,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.name ?? 'Unknown Shop',
                    style: AppFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        branch.rating?.toStringAsFixed(1) ?? '4.5',
                        style: AppFonts.inter(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        branch.distance ?? '0.4 km',
                        style: AppFonts.inter(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
