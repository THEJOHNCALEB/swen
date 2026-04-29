import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedArticleList extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;

  const AnimatedArticleList({
    super.key,
    required this.children,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index]
            .animate()
            .fadeIn(
              duration: 300.ms,
              delay: (50 * index).ms,
            )
            .slideY(
              begin: 0.1,
              end: 0,
              duration: 300.ms,
              delay: (50 * index).ms,
              curve: Curves.easeOut,
            );
      },
    );
  }
}
