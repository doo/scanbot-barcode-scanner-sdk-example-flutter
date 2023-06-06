import 'package:barcode_scanner/json/common_data.dart';
import 'package:flutter/material.dart';

class BarcodeFormatItemWidget extends StatelessWidget {
  final BarcodeFormat format;
  final bool selected;
  final ValueChanged<bool?> onSelect;

  BarcodeFormatItemWidget(this.format, this.selected, {required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 16, bottom: 16),
            child: Row(
              children: <Widget>[
                Text(
                  format.name,
                  style: const TextStyle(inherit: true, color: Colors.black),
                ),
                Expanded(child: Container()),
                Checkbox(value: selected, onChanged: onSelect)
              ],
            ),
          ),
        ],
      ),
    );
  }
}