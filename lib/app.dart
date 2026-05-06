import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'app/app_menu.dart';
import 'app/swen_shortcuts.dart';

final searchFocusNode = FocusNode();

class SwenApp extends ConsumerWidget {
  const SwenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwenMenuBar(
      child: SwenShortcuts(
        searchFocusNode: searchFocusNode,
        child: MaterialApp.router(
          title: 'Swen',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.black,
              brightness: Brightness.light,
              primary: AppColors.black,
              onPrimary: AppColors.white,
              surface: AppColors.surface,
              onSurface: AppColors.black,
            ),
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: AppTextStyles.dmSans,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.black,
              elevation: 0,
              centerTitle: false,
            ),
            cardTheme: const CardThemeData(
              color: AppColors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: AppColors.grey6, width: 1),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.grey7,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey6, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey6, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.black, width: 1),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: AppColors.surface,
              indicatorColor: Colors.transparent,
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: AppColors.black);
                }
                return const IconThemeData(color: AppColors.grey4);
              }),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTextStyles.caption.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  );
                }
                return AppTextStyles.caption.copyWith(
                  color: AppColors.grey4,
                );
              }),
            ),
          ),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
