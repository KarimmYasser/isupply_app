import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/home_controller.dart';

class Search extends StatelessWidget {
  final HomeController controller;
  const Search(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TextField(
        focusNode: controller.searchFocusNode,
        onChanged: controller.onSearch,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'أدخل اسم المنتج',
          contentPadding: EdgeInsets.zero,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefix: Container(
            margin: const EdgeInsets.only(left: 5, top: 5),
            child: SvgPicture.asset(
              "assets/svg/search.svg",
              height: 20,
              width: 20,
              fit: BoxFit.fill,
            ),
          ),
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.black.withAlpha(178),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AnimateExpansion extends StatefulWidget {
  final Widget child;
  final bool animate;
  final double axisAlignment;

  const AnimateExpansion({super.key, 
    this.animate = false,
    required this.axisAlignment,
    required this.child,
  });

  @override
  _AnimateExpansionState createState() => _AnimateExpansionState();
}

class _AnimateExpansionState extends State<AnimateExpansion>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  void _toggle() {
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _toggle();
  }

  @override
  void didUpdateWidget(AnimateExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      axisAlignment: -1.0,
      sizeFactor: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
