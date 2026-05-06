import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SwenSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const SwenSearchBar({
    super.key,
    required this.onSearch,
    this.onClear,
    this.focusNode,
  });

  @override
  State<SwenSearchBar> createState() => _SwenSearchBarState();
}

class _SwenSearchBarState extends State<SwenSearchBar> {
  final TextEditingController _controller = TextEditingController();
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: _hasFocus ? AppColors.surface : AppColors.grey7,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _hasFocus ? AppColors.black : Colors.transparent,
          width: _hasFocus ? 1.5 : 0,
        ),
        boxShadow: [
          if (_hasFocus)
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _hasFocus ? AppColors.black : AppColors.grey6.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_rounded,
              color: _hasFocus ? AppColors.white : AppColors.grey4,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: AppTextStyles.body.copyWith(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Search articles, topics...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.grey5,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSearch,
              onChanged: (value) {
                setState(() {});
                if (value.isEmpty && widget.onClear != null) {
                  widget.onClear!();
                }
              },
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() {});
                widget.onClear?.call();
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.grey6.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.grey3,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
