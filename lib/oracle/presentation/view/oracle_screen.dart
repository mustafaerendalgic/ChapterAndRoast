import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/oracle/presentation/mvvm/oracle_view_model.dart';
import 'package:provider/provider.dart';

class OracleScreen extends StatefulWidget {
  const OracleScreen({super.key});

  @override
  State<OracleScreen> createState() => _OracleScreenState();
}

class _OracleScreenState extends State<OracleScreen> {
  final OracleViewModel _viewModel = OracleViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'KAHVE FALI ORACLE',
            style: AppFonts.inter(
              color: AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        body: Consumer<OracleViewModel>(
          builder: (context, vm, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'Kaderin Yudumu',
                    style: AppFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Fincanınızdaki desenleri okuyun,\ngeleceğinize dair izleri keşfedin.',
                    textAlign: TextAlign.center,
                    style: AppFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Ritual Area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Mystical framing icons
                          const Positioned(top: -12, child: Icon(Icons.wb_sunny_outlined, color: AppColors.gold, size: 24)),
                          const Positioned(bottom: -12, child: Icon(Icons.wb_sunny_outlined, color: AppColors.gold, size: 24)),
                          
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: vm.isLoading 
                              ? const _PulsingRitualEye()
                              : vm.currentFortune != null 
                                ? TweenAnimationBuilder<double>(
                                    key: const ValueKey('fortune_reveal'),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 800),
                                    builder: (context, opacity, child) {
                                      return Opacity(
                                        opacity: opacity.clamp(0.0, 1.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'KEHANET AÇIKLANDI',
                                                style: AppFonts.inter(
                                                  color: AppColors.gold.withValues(alpha: 0.6),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 3,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.star_outline, color: AppColors.gold.withValues(alpha: 0.4), size: 14),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Text(
                                                      vm.currentOmenTitle ?? 'BİLİNMEYEN',
                                                      style: AppFonts.playfairDisplay(
                                                        color: AppColors.gold,
                                                        fontSize: 28,
                                                        fontWeight: FontWeight.w700,
                                                        letterSpacing: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(Icons.star_outline, color: AppColors.gold.withValues(alpha: 0.4), size: 14),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                              Container(
                                                padding: const EdgeInsets.all(24),
                                                decoration: BoxDecoration(
                                                  color: AppColors.bgCard.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
                                                ),
                                                child: Text(
                                                  vm.currentFortune!,
                                                  textAlign: TextAlign.center,
                                                  style: AppFonts.inter(
                                                    color: AppColors.textPrimary,
                                                    fontSize: 15,
                                                    height: 1.6,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                '§',
                                                style: TextStyle(color: AppColors.gold, fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Column(
                                    key: const ValueKey('vessel_ready'),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        color: AppColors.gold.withValues(alpha: 0.2),
                                        size: 48,
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        'FİNCANINIZ HAZIR',
                                        style: AppFonts.inter(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Action Button
                  SizedBox(
                    width: 220,
                    height: 70,
                    child: OutlinedButton(
                      onPressed: vm.rights > 0 && !vm.isLoading ? () => vm.generateFortune() : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D1B1B).withValues(alpha: 0.4),
                        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.3), width: 1),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Falına Bak',
                            style: AppFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vm.rights > 0 ? 'YENİ BİR NETLİK ARA' : 'FAL HAKKINIZ KALMADI',
                            style: AppFonts.inter(
                              color: AppColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Rights indicator for reliability
                  Text(
                    'Mevcut Fal Haklarınız: ${vm.rights}',
                    style: AppFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PulsingRitualEye extends StatelessWidget {
  const _PulsingRitualEye();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.4, end: 1.0),
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutSine,
        child: const Icon(
          Icons.remove_red_eye_outlined,
          color: AppColors.gold,
          size: 64,
        ),
        builder: (context, value, child) {
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: (0.3 * value).clamp(0.0, 1.0)),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Opacity(
              opacity: (0.5 + (0.5 * value)).clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
