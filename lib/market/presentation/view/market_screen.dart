import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/core/widgets/caffe_app_bar.dart';
import 'package:gdg_campus_coffee/market/domain/entity/catalog_product.dart';
import 'package:gdg_campus_coffee/market/presentation/mvvm/market_view_model.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/menu/presentation/view/product_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final MarketViewModel _viewModel = MarketViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
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
          : RefreshIndicator(
              onRefresh: _viewModel.fetchCatalogProducts,
              color: AppColors.gold,
              backgroundColor: AppColors.bgCard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Text(
                        'CURATED ESSENTIALS',
                        style: AppFonts.inter(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                      child: Text(
                        'The Shop',
                        style: AppFonts.playfairDisplay(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Text(
                        'Tactile tools for the thoughtful reader and the meticulous brewer.',
                        style: AppFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (_viewModel.catalogProducts.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Text(
                            'No items in the shop right now.',
                            style: AppFonts.inter(color: AppColors.textMuted),
                          ),
                        ),
                      )
                    else
                      ...(_viewModel.catalogProducts.map((p) => _ProductCard(product: p)).toList()),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final CatalogProduct product;
  const _ProductCard({required this.product});

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
      onTap: () {
        // Map CatalogProduct to Product for the detail screen
        final mappedProduct = Product(
          name: product.name,
          description: product.description,
          price: product.price,
          image: product.image,
          category: product.category?.toUpperCase() ?? 'EQUIPMENT',
          subTitle: 'Premium Gear',
          provenanceBody: 'Designed for the modern nomad and the meticulous brewer, this artifact represents the intersection of utility and aesthetic. Built to withstand the rigors of the journey while maintaining the thermal integrity of your brew.',
          origin: 'International',
          roastLevel: 'N/A',
          process: 'Industrial',
          elevation: 'Sea Level',
          ritualGenre: 'Exploration & Travel',
          ritualVessel: product.name,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: mappedProduct),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: Stack(
              children: [
                // Full-bleed image
                Positioned.fill(
                  child: _buildImage(product.image),
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
                          AppColors.bgDark.withValues(alpha: 0.68),
                          AppColors.bgDark.withValues(alpha: 0.95),
                        ],
                        stops: const [0.0, 0.42, 0.72, 1.0],
                      ),
                    ),
                  ),
                ),
                // Category Badge
                if (product.category != null)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.bgDark.withValues(alpha: 0.70),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        product.category!,
                        style: AppFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                // Text overlaid at the bottom
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
                              product.name ?? 'Unknown Item',
                              style: AppFonts.playfairDisplay(
                                color: AppColors.textPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                shadows: [const Shadow(color: Colors.black54, blurRadius: 8)],
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              product.description ?? '',
                              style: AppFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: AppFonts.playfairDisplay(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          shadows: [const Shadow(color: Colors.black54, blurRadius: 6)],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
