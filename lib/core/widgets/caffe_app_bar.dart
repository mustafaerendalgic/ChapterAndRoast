import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/shop/presentation/view/cart_screen.dart';
import 'package:gdg_campus_coffee/shop/presentation/mvvm/cart_view_model.dart';
import 'package:gdg_campus_coffee/oracle/data/service/oracle_service.dart';
import 'package:gdg_campus_coffee/oracle/presentation/view/oracle_screen.dart';

class CaffeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CaffeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navBg,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.menu_book_rounded, color: AppColors.textPrimary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Caffè & Codex',
                  style: AppFonts.playfairDisplay(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Oracle Icon (Left of Cart)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OracleScreen()),
                  ),
                  child: StreamBuilder<int>(
                    stream: OracleService().streamFortuneRights(),
                    builder: (context, snapshot) {
                      final rights = snapshot.data ?? 0;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.bgCard.withValues(alpha: 0.5),
                              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3), width: 1.5),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 18),
                          ),
                          if (rights > 0)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.bgDark, width: 1),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$rights',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Cart Icon
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                  child: ListenableBuilder(
                    listenable: CartViewModel(),
                    builder: (context, _) {
                      final count = CartViewModel().items.length;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.bgCard,
                              border: Border.all(color: AppColors.border, width: 1.5),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined, color: AppColors.textSecondary, size: 18),
                          ),
                          if (count > 0)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.gold,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$count',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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
