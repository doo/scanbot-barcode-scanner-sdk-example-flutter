import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

import '../../utility/utils.dart';
import 'item.dart';

class BarcodesFormatSelectorWidget extends StatelessWidget {
  const BarcodesFormatSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Scanned barcodes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ValueListenableBuilder<Set<BarcodeFormat>>(
        valueListenable: selectedFormatsNotifier,
        builder: (context, selectedFormats, _) {
          return ListView.builder(
            itemCount: BarcodeFormats.all.length,
            itemBuilder: (context, index) {
              final item = BarcodeFormats.all[index];
              final isSelected = selectedFormats.contains(item);

              return BarcodeFormatItemWidget(
                item,
                isSelected,
                onSelect: (selected) {
                  final updatedFormats = Set<BarcodeFormat>.from(selectedFormats);
                  if (selected == true) {
                    updatedFormats.add(item);
                  } else {
                    updatedFormats.remove(item);
                  }
                  selectedFormatsNotifier.value = updatedFormats;
                },
              );
            },
          );
        },
      ),
    );
  }
}