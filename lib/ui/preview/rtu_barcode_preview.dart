import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

import '../../utility/generic_document_helper.dart';
import 'barcode_card.dart';

class BarcodesUiResultPreviewWidget extends StatelessWidget {
  final BarcodeScannerUiResult preview;

  const BarcodesUiResultPreviewWidget(this.preview, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        iconTheme: const IconThemeData(),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        title: Text('Scanned RTU Ui barcodes', style: const TextStyle(color: Colors.black)),
      ),
      body: ListView.builder(
        itemCount: preview.items.length,
        itemBuilder: (context, index) {
          final item = preview.items[index];
          return
            BarcodeCard(
              sourceImage: item.barcode.sourceImage?.buffer != null ? Image.memory(item.barcode.sourceImage!.buffer!) : null,
              format: item.barcode.format.toString(),
              text: item.barcode.text ?? '',
              extraWidget: GenericDocumentHelper.wrappedGenericDocumentField(item.barcode.extractedDocument),
            );
        },
      ),
    );
  }
}