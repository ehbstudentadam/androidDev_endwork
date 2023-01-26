import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final Widget widget;

  const Skeleton({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget,
    );
  }
}

