import 'package:flutter/material.dart';

class BarcodeCard extends StatelessWidget {
  final String format;
  final String text;
  final Widget? extraWidget;
  final Image? sourceImage;

  const BarcodeCard({
    required this.format,
    required this.text,
    this.extraWidget,
    this.sourceImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: sourceImage),
            Text(format, style: const TextStyle(color: Colors.black)),
            Text(text, style: const TextStyle(color: Colors.black)),
            if (extraWidget != null) extraWidget!,
          ],
        ),
      ),
    );
  }
}