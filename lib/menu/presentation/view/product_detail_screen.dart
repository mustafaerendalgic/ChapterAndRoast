import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/shop/presentation/mvvm/cart_view_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = CartViewModel();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPricingSection(),
                  const SizedBox(height: 32),
                  _buildAddButton(context, cart),
                  const SizedBox(height: 48),
                  _buildProvenanceSection(),
                  const SizedBox(height: 48),
                  _buildSpecsGrid(),
                  const SizedBox(height: 56),
                  _buildRitualSection(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 520,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Hero Image
            if (product.image != null)
              product.image!.startsWith('http')
                  ? Image.network(product.image!, fit: BoxFit.cover)
                  : Image.asset(product.image!, fit: BoxFit.cover)
            else
              Container(color: AppColors.bgCard),
            
            // 2. Text and Info Layer with Color Fade (Pure and Fast)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bgDark.withValues(alpha: 0.0),
                      AppColors.bgDark.withValues(alpha: 0.7),
                      AppColors.bgDark,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 30.0, end: 0.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, value),
                      child: Opacity(
                        opacity: (1 - (value / 30)).clamp(0.0, 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.category?.toUpperCase() ?? 'PREMIUM ROAST NO. 042',
                              style: AppFonts.inter(
                                color: AppColors.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.name ?? 'The Artifact',
                              style: AppFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              product.quote ?? '"A liquid sonnet for the midnight scholar, where ink-stained thoughts meet the dark heart of the bean."',
                              style: AppFonts.inter(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.subTitle ?? 'Single Origin - 250g',
              style: AppFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${product.price?.toStringAsFixed(2) ?? '18.00'}',
              style: AppFonts.playfairDisplay(
                color: AppColors.gold,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        // Temperature Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: (product.isHot) 
              ? const Color(0xFF3D2112).withValues(alpha: 0.4) 
              : const Color(0xFF1A2A3D).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: (product.isHot) ? AppColors.tagIntense : AppColors.tagSmooth,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                product.isHot ? Icons.local_fire_department_rounded : Icons.ac_unit_rounded,
                color: product.isHot ? AppColors.tagIntense : AppColors.tagSmooth,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                product.isHot ? 'SERVED HOT' : 'ICED CRAFT',
                style: AppFonts.inter(
                  color: product.isHot ? AppColors.tagIntense : AppColors.tagSmooth,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, CartViewModel cart) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          cart.addItem(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} added to your bag'),
              backgroundColor: AppColors.gold,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ),
        child: Text(
          'ADD TO BAG',
          style: AppFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
          ),
        ),
      ),
    );
  }

  Widget _buildProvenanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 2, height: 18, color: AppColors.gold),
            const SizedBox(width: 10),
            Text(
              'PROVENANCE & PROFILE',
              style: AppFonts.inter(
                color: AppColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          product.provenanceBody ?? 'Harvested from the shade-grown canopies of the Yirgacheffe highlands, these heirloom varietals are processed with a meticulous double-fermentation technique. The result is a profile that defies the traditional dark roast, maintaining a startling clarity of origin amidst the deep carbon notes.',
          style: AppFonts.inter(
            color: AppColors.textPrimary.withValues(alpha: 0.85),
            fontSize: 16,
            height: 1.7,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: (product.flavorNotes ?? ['Dark Chocolate', 'Toasted Oak', 'Midnight Berry']).map((note) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgCard.withValues(alpha: 0.3),
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              note,
              style: AppFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSpecsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childAspectRatio: 1.3, // Increased height to prevent overflow
      children: [
        _SpecTile(icon: Icons.public_rounded, label: 'Origin', value: product.origin ?? 'Ethiopia'),
        _SpecTile(icon: Icons.local_fire_department_rounded, label: 'Roast Level', value: product.roastLevel ?? 'Dark/Bold'),
        _SpecTile(icon: Icons.water_drop_rounded, label: 'Process', value: product.process ?? 'Washed'),
        _SpecTile(icon: Icons.landscape_rounded, label: 'Elevation', value: product.elevation ?? '1800m'),
      ],
    );
  }

  Widget _buildRitualSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Ritual',
          style: AppFonts.playfairDisplay(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 28),
        _RitualCard(
          label: 'GENRE PAIRING',
          value: product.ritualGenre ?? 'Existential Philosophy',
          imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=800',
        ),
        const SizedBox(height: 24),
        _RitualCard(
          label: 'VESSEL PAIRING',
          value: product.ritualVessel ?? 'Matte Obsidian Stein',
          imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?auto=format&fit=crop&q=80&w=800',
        ),
      ],
    );
  }
}

class _SpecTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const Spacer(),
          Text(
            label.toUpperCase(),
            style: AppFonts.inter(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RitualCard extends StatelessWidget {
  final String label;
  final String value;
  final String imageUrl;

  const _RitualCard({required this.label, required this.value, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.95)],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppFonts.inter(
                    color: AppColors.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: AppFonts.playfairDisplay(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
