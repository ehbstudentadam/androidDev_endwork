import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final Widget widget;

  const Skeleton({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //todo
          },
          icon: const Icon(Icons.account_circle),
        ),
        title: const Center(child: Text('DROP')),
        actions: [
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                //code to execute when this button is pressed
              }),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                //code to execute when this button is pressed
              }),
        ],
      ),
      body: SafeArea(
        child: widget,
      ),
    );
  }
}
