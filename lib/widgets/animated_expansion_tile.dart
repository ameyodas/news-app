import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class AnimatedExpansionTile extends StatefulWidget {
  final List<Widget> children;

  const AnimatedExpansionTile({
    super.key,
    required this.children,
  });

  @override
  State<AnimatedExpansionTile> createState() => _AnimatedExpansionTileState();
}

class _AnimatedExpansionTileState extends State<AnimatedExpansionTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _handleTap(bool expanded) {
    setState(() {
      _expanded = expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: RotationTransition(
          turns: _iconTurns,
          child: const Icon(
            FluentIcons.chevron_down_24_regular,
          ),
        ),
        showTrailingIcon: false,
        shape: Border.all(color: Colors.transparent),
        expansionAnimationStyle: AnimationStyle(
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
          duration: const Duration(milliseconds: 250),
          reverseDuration: const Duration(milliseconds: 200),
        ),
        onExpansionChanged: _handleTap,
        children: widget.children,
      ),
    );
  }
}
