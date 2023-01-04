import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final Widget widget;

  const Skeleton({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7A727),
        title: const Center(child: Text('2DO')),
      ),
      body: SafeArea(
        child: widget,
      ),
    );
  }
}