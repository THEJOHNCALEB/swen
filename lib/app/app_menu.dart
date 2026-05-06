import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/utils/platform_utils.dart';
import '../core/constants/app_colors.dart';

class SwenMenuBar extends StatelessWidget {
  final Widget child;
  const SwenMenuBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!PlatformUtils.isDesktop) return child;

    return PlatformMenuBar(
      menus: [
        PlatformMenu(label: 'File', menus: [
          PlatformMenuItem(
            label: 'New Window',
            shortcut: const SingleActivator(
                LogicalKeyboardKey.keyN, meta: true),
            onSelected: () {},
          ),
          PlatformMenuItemGroup(members: [
            PlatformMenuItem(
              label: 'Export Bookmarks as CSV',
              shortcut: const SingleActivator(
                  LogicalKeyboardKey.keyE, meta: true),
              onSelected: () {},
            ),
          ]),
          PlatformMenuItem(
            label: 'Quit Swen',
            shortcut: const SingleActivator(
                LogicalKeyboardKey.keyQ, meta: true),
            onSelected: () => SystemNavigator.pop(),
          ),
        ]),
        PlatformMenu(label: 'Edit', menus: [
          PlatformMenuItem(
            label: 'Copy Article Link',
            onSelected: () {},
          ),
        ]),
        PlatformMenu(label: 'View', menus: [
          PlatformMenuItem(
            label: 'Feed',
            shortcut: const SingleActivator(
                LogicalKeyboardKey.digit1, meta: true),
            onSelected: () => _navigate(context, '/'),
          ),
          PlatformMenuItem(
            label: 'Categories',
            shortcut: const SingleActivator(
                LogicalKeyboardKey.digit2, meta: true),
            onSelected: () =>
                _navigate(context, '/categories'),
          ),
          PlatformMenuItem(
            label: 'Search',
            shortcut: const SingleActivator(
                LogicalKeyboardKey.digit3, meta: true),
            onSelected: () => _navigate(context, '/search'),
          ),
          PlatformMenuItem(
            label: 'Saved Articles',
            shortcut: const SingleActivator(
                LogicalKeyboardKey.digit4, meta: true),
            onSelected: () =>
                _navigate(context, '/bookmarks'),
          ),
          PlatformMenuItemGroup(members: [
            PlatformMenuItem(
              label: 'Refresh Feed',
              shortcut: const SingleActivator(
                  LogicalKeyboardKey.keyR, meta: true),
              onSelected: () {},
            ),
          ]),
        ]),
        PlatformMenu(label: 'Help', menus: [
          PlatformMenuItem(
            label: 'Keyboard Shortcuts',
            onSelected: () => _showShortcutsDialog(context),
          ),
          PlatformMenuItem(
            label: 'About Swen',
            onSelected: () => _showAbout(context),
          ),
        ]),
      ],
      child: child,
    );
  }

  void _navigate(BuildContext context, String route) {
    GoRouter.of(context).go(route);
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Swen',
      applicationVersion: '1.0.0',
      applicationLegalese: '\u{a9} 2024 Swen',
      children: [
        const SizedBox(height: 12),
        const Text('A clean, monochrome news app.'),
      ],
    );
  }

  void _showShortcutsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.grey6)),
        title: const Text('Keyboard Shortcuts'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ShortcutRow(shortcutKey: 'Cmd/Ctrl + 1', action: 'Go to Feed'),
            _ShortcutRow(
                shortcutKey: 'Cmd/Ctrl + 2', action: 'Go to Categories'),
            _ShortcutRow(
                shortcutKey: 'Cmd/Ctrl + 3', action: 'Go to Search'),
            _ShortcutRow(
                shortcutKey: 'Cmd/Ctrl + 4', action: 'Go to Saved'),
            _ShortcutRow(
                shortcutKey: 'Cmd/Ctrl + R', action: 'Refresh Feed'),
            _ShortcutRow(
                shortcutKey: 'Cmd/Ctrl + F', action: 'Focus Search'),
            _ShortcutRow(shortcutKey: 'Escape', action: 'Go Back'),
            _ShortcutRow(
                shortcutKey: '?', action: 'Show Shortcuts'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  final String shortcutKey;
  final String action;
  const _ShortcutRow({required this.shortcutKey, required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(shortcutKey,
                style: const TextStyle(
                    fontFamily: 'DM Mono',
                    fontSize: 11,
                    color: AppColors.black)),
          ),
          const SizedBox(width: 12),
          Text(action,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.grey3)),
        ],
      ),
    );
  }
}
