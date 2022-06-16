import 'package:flutter/material.dart';

class PageTest extends StatelessWidget {
  String texte;
  PageTest({super.key, required this.texte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(texte),
      ),
      body: Center(
        child: Text(texte),
      ),
    );
  }
}
