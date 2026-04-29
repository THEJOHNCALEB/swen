import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/categories/category_feed_screen.dart';
import '../../features/article_detail/article_detail_screen.dart';
import '../models/article.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    ),
    GoRoute(
      path: '/category/:category',
      pageBuilder: (context, state) {
        final category = state.pathParameters['category']!;
        return _buildSlideUp(state, CategoryFeedScreen(category: category));
      },
    ),
    GoRoute(
      path: '/article',
      pageBuilder: (context, state) {
        final article = state.extra as Article;
        return _buildSlideUp(state, ArticleDetailScreen(article: article));
      },
    ),
  ],
);

CustomTransitionPage<void> _buildSlideUp(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnim = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(curvedAnim),
        child: FadeTransition(
          opacity: curvedAnim,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 450),
  );
}
