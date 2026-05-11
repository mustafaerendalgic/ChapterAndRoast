import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/core/widgets/caffe_app_bar.dart';
import 'package:gdg_campus_coffee/recommendation/presentation/mvvm/recommendation_view_model.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final TextEditingController _controller = TextEditingController();
  final RecommendationViewModel _viewModel = RecommendationViewModel();

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
    _controller.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _handleAskAi() {
    if (_controller.text.trim().isNotEmpty) {
      _viewModel.askAi(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const CaffeAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAskAi,
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.bgDark,
        elevation: 4,
        child: _viewModel.loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.bgDark,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.auto_awesome, size: 26),
      ),
      body: _viewModel.loading && _viewModel.recommendations.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : RefreshIndicator(
              onRefresh: _viewModel.init,
              color: AppColors.gold,
              backgroundColor: AppColors.bgCard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero image
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Image.asset(
                            'assets/images/hero_coffee.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Heading
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                      child: Text(
                        'Ask me anything\nabout your next\nbrew...',
                        style: AppFonts.playfairDisplay(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'I am your digital sommelier, weaving together the chemistry of the bean and the prose of the page.',
                        style: AppFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Search field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _handleAskAi(),
                          enabled: !_viewModel.loading,
                          style: AppFonts.inter(color: AppColors.textPrimary, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Whisper your cravings...',
                            hintStyle: AppFonts.inter(color: AppColors.textMuted, fontSize: 15),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            suffixIcon: IconButton(
                              onPressed: _handleAskAi,
                              icon: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 22),
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (_viewModel.aiAnswer != null)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI RECOMMENDATION',
                                    style: AppFonts.inter(
                                      color: AppColors.gold,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _viewModel.aiAnswer!,
                                style: AppFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Suggestion Boxes (Stacked Vertical)
                    if (_viewModel.suggestions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: _viewModel.suggestions.map((suggestion) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () {
                                _controller.text = suggestion;
                                _handleAskAi();
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.border, width: 0.8),
                                ),
                                child: Text(
                                  '"$suggestion"',
                                  style: AppFonts.inter(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    
                    // Previous Cravings section
                    if (_viewModel.recommendations.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.history_rounded, color: AppColors.gold, size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Previous Cravings',
                                    style: AppFonts.inter(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'YESTERDAY',
                                style: AppFonts.inter(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '"${_viewModel.recommendations.first.question ?? ''}"',
                                style: AppFonts.playfairDisplay(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Brewing Rituals card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 130,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/leather_books.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                height: 130,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.bgDark.withValues(alpha: 0.7), AppColors.bgDark.withValues(alpha: 0.3)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.inventory_2_outlined, color: AppColors.gold, size: 22),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Brewing Rituals',
                                      style: AppFonts.inter(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Explore 12 new pairing guides curated\nfor your library.',
                                      style: AppFonts.inter(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                        height: 1.5,
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
                  ],
                ),
              ),
            ),
    );
  }
}
