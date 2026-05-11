import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/core/widgets/caffe_app_bar.dart';
import 'package:gdg_campus_coffee/menu/presentation/mvvm/menu_view_model.dart';
import 'package:gdg_campus_coffee/menu/presentation/view/product_detail_screen.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final PageController _pageController;
  final MenuViewModel _viewModel = MenuViewModel();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Full-width items with 16dp padding
    _pageController = PageController(viewportFraction: 1.0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          : RefreshIndicator(
              onRefresh: _viewModel.fetchProducts,
              color: AppColors.gold,
              backgroundColor: AppColors.bgCard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header labels
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Text(
                        'CURRENT SELECTION',
                        style: AppFonts.inter(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Text(
                        'Popular Choices',
                        style: AppFonts.playfairDisplay(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    // Horizontal Carousel
                    if (_viewModel.featuredProducts.isNotEmpty)
                      SizedBox(
                        height: 380, 
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _viewModel.featuredProducts.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final diff = (index - _currentPage).abs();
                            // Very subtle scale for full-width transition
                            final scale = (1 - (diff * 0.05)).clamp(0.95, 1.0);
                            final opacity = (1 - (diff * 0.5)).clamp(0.5, 1.0);

                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: scale, end: scale),
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: _FeaturedCard(
                                      item: _viewModel.featuredProducts[index],
                                      isCurrent: diff < 0.5,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    else if (!_viewModel.loading && _viewModel.archiveProducts.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                          child: Column(
                            children: [
                              const Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'The menu is currently empty.\nCheck your Firestore connection or seeding logs.',
                                textAlign: TextAlign.center,
                                style: AppFonts.inter(color: AppColors.textMuted, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Page indicator dots
                    if (_viewModel.featuredProducts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_viewModel.featuredProducts.length, (index) {
                            final diff = (index - _currentPage).abs();
                            final isActive = diff < 0.5;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 24 : 8,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.gold : AppColors.textMuted,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ),
                      ),

                    // Extended Archive
                    if (_viewModel.archiveProducts.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Text(
                          'THE EXTENDED ARCHIVE',
                          style: AppFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(height: 1, color: AppColors.border),
                      ),
                      ...(_viewModel.archiveProducts.map((item) => _ArchiveRow(item: item)).toList()),
                    ],

                    // Reserve button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.bgDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'RESERVE A TASTING',
                            style: AppFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Product item;
  final bool isCurrent;

  const _FeaturedCard({
    required this.item,
    required this.isCurrent,
  });

  Widget _buildImage(String? path) {
    if (path == null) return Container(color: AppColors.bgCard);
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    return Image.asset(path, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: item)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Full-bleed image
              Positioned.fill(
                child: _buildImage(item.image),
              ),
              // Gradient fade
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.bgDark.withValues(alpha: 0.0),
                        AppColors.bgDark.withValues(alpha: 0.72),
                        AppColors.bgDark.withValues(alpha: 0.96),
                      ],
                      stops: const [0.0, 0.35, 0.70, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.name ?? 'Unknown',
                            style: AppFonts.playfairDisplay(
                              color: AppColors.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                const Shadow(color: Colors.black54, blurRadius: 8),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description ?? '',
                            style: AppFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: AppFonts.playfairDisplay(
                        color: AppColors.gold,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          const Shadow(color: Colors.black54, blurRadius: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchiveRow extends StatelessWidget {
  final Product item;
  const _ArchiveRow({required this.item});

  Color _getBadgeColor(String badge) {
    switch (badge.toUpperCase()) {
      case 'BOLD':
        return AppColors.tagBold;
      case 'INTENSE':
        return AppColors.tagIntense;
      case 'SMOOTH':
        return AppColors.tagSmooth;
      case 'MILD':
        return AppColors.tagMild;
      default:
        return AppColors.gold;
    }
  }

  Widget _buildImage(String? path) {
    if (path == null) return Container(color: AppColors.bgCard);
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover, width: 40, height: 40);
    }
    return Image.asset(path, fit: BoxFit.cover, width: 40, height: 40);
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = item.badge != null ? _getBadgeColor(item.badge!) : AppColors.gold;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: item)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '',
                    style: AppFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description ?? '',
                    style: AppFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
              style: AppFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (item.badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item.badge!,
                  style: AppFonts.inter(
                    color: badgeColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
