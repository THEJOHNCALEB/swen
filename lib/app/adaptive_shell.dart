import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../core/utils/responsive.dart';
import '../core/constants/app_colors.dart';

class AdaptiveShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdaptiveShell({super.key, required this.navigationShell});

  static const _destinations = [
    (icon: Icons.newspaper_outlined, label: 'Feed', route: '/'),
    (
      icon: Icons.grid_view_outlined,
      label: 'Categories',
      route: '/categories'
    ),
    (icon: Icons.search_outlined, label: 'Search', route: '/search'),
    (
      icon: Icons.bookmark_border_rounded,
      label: 'Saved',
      route: '/bookmarks'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final layout = Responsive.of(context);

    return switch (layout) {
      ScreenLayout.mobile => _MobileShell(
          child: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onTap: (i) => _onDestinationSelected(navigationShell, i),
        ),
      ScreenLayout.tablet => _TabletShell(
          child: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onTap: (i) => _onDestinationSelected(navigationShell, i),
        ),
      ScreenLayout.desktop => _DesktopShell(
          child: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onTap: (i) => _onDestinationSelected(navigationShell, i),
        ),
    };
  }

  void _onDestinationSelected(
      StatefulNavigationShell shell, int index) {
    shell.goBranch(
      index,
      initialLocation: index == shell.currentIndex,
    );
  }
}

class _MobileShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _MobileShell(
      {required this.child,
      required this.selectedIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onTap,
          backgroundColor: AppColors.surface,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: AdaptiveShell._destinations
              .map((d) => NavigationDestination(
                    icon: Icon(d.icon),
                    label: d.label,
                  ))
              .toList(),
        ),
      );
}

class _TabletShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _TabletShell(
      {required this.child,
      required this.selectedIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onTap,
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.grey7,
            labelType: NavigationRailLabelType.all,
            destinations: AdaptiveShell._destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon, color: AppColors.grey5),
                      selectedIcon:
                          Icon(d.icon, color: AppColors.black),
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(width: 1, color: AppColors.grey6),
          Expanded(child: child),
        ]),
      );
}

class _DesktopShell extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _DesktopShell(
      {required this.child,
      required this.selectedIndex,
      required this.onTap});

  @override
  State<_DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<_DesktopShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _firstBuild = false);
    });
  }

  bool _firstBuild = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        SizedBox(
          width: 220,
          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.fromLTRB(20, 28, 20, 24),
                      child: Text('Swen',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black)),
                    ),
                    const Divider(
                        height: 1, color: AppColors.grey6),
                    const SizedBox(height: 8),
                    ...AdaptiveShell._destinations
                        .asMap()
                        .entries
                        .map((entry) {
                      final i = entry.key;
                      final d = entry.value;
                      final selected =
                          i == widget.selectedIndex;
                      return _SidebarItem(
                        icon: d.icon,
                        label: d.label,
                        selected: selected,
                        onTap: () => widget.onTap(i),
                      );
                    }),
                  ],
                )
              .animate()
              .slideX(
                  begin: _firstBuild ? -0.08 : 0,
                  end: 0,
                  duration: _firstBuild ? 350.ms : 0.ms,
                  curve: Curves.easeOutCubic)
              .fadeIn(
                  duration: _firstBuild ? 300.ms : 0.ms),
        ),
        const VerticalDivider(width: 1, color: AppColors.grey6),
        Expanded(child: widget.child),
      ]),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SidebarItem(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.selected
                  ? AppColors.grey7
                  : _hovered
                      ? AppColors.grey7.withOpacity(0.6)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Icon(widget.icon,
                  size: 18,
                  color: widget.selected
                      ? AppColors.black
                      : AppColors.grey4),
              const SizedBox(width: 12),
              Text(widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.selected
                        ? FontWeight.w500
                        : FontWeight.w300,
                    color: widget.selected
                        ? AppColors.black
                        : AppColors.grey3,
                  )),
              if (widget.selected) ...[
                const Spacer(),
                Container(
                    width: 3,
                    height: 3,
                    decoration: const BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle)),
              ],
            ]),
          ),
        ),
      );
}
