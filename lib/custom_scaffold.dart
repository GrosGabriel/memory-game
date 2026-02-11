import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;

  CustomScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: const Color(0xFF1F1F1E),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960),
          child : Container (
          color: const Color.fromARGB(255, 94, 93, 91),
          child: child,
          
          )
        ),
      ),
    );
  }

}