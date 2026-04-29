import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/doodle_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lineController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();

    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      _lineController.forward();
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DoodleBackground(
        opacity: 0.03,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _lineAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 5,
                        height: 44 * _lineAnimation.value,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.black, AppColors.grey4],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 14),
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.display.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 700.ms,
                        delay: 200.ms,
                        curve: Curves.easeOut,
                      )
                      .slideX(
                        begin: -0.1,
                        end: 0,
                        duration: 700.ms,
                        delay: 200.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.tagline,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 14,
                  letterSpacing: 3,
                  color: AppColors.grey4,
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 600.ms,
                    delay: 800.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 600.ms,
                    delay: 800.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
