import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/utils/platform_utils.dart';
import '../providers/news_provider.dart';

class SwenShortcuts extends ConsumerWidget {
  final Widget child;
  final FocusNode searchFocusNode;

  const SwenShortcuts({
    super.key,
    required this.child,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!PlatformUtils.isDesktopOrWeb) return child;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.digit1,
                meta: true): () {
          context.go('/');
        },
        const SingleActivator(LogicalKeyboardKey.digit2,
                meta: true): () {
          context.go('/categories');
        },
        const SingleActivator(LogicalKeyboardKey.digit3,
                meta: true): () {
          context.go('/search');
        },
        const SingleActivator(LogicalKeyboardKey.digit4,
                meta: true): () {
          context.go('/bookmarks');
        },
        const SingleActivator(LogicalKeyboardKey.keyR,
                meta: true): () {
          ref.invalidate(topHeadlinesProvider('general'));
        },
        const SingleActivator(LogicalKeyboardKey.keyF,
                meta: true): () {
          context.go('/search');
          searchFocusNode.requestFocus();
        },
        const SingleActivator(
            LogicalKeyboardKey.escape): () {
          if (context.canPop()) {
            context.pop();
          }
        },
        const SingleActivator(LogicalKeyboardKey.slash): () {
          final routerState = GoRouterState.of(context);
          final loc = routerState.uri.path;
          if (loc.startsWith('/search')) {
            searchFocusNode.requestFocus();
          } else {
            GoRouter.of(context).go('/search');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              searchFocusNode.requestFocus();
            });
          }
        },
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}
