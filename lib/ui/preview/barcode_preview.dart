import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

import '../../utility/generic_document_helper.dart';
import 'barcode_card.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  final List<BarcodeItem> barcodeItems;

  const BarcodesResultPreviewWidget(this.barcodeItems, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        title: Text('Scanned barcodes', style: const TextStyle(color: Colors.black)),
      ),
      body:  ListView.builder(
        itemCount: barcodeItems.length,
        itemBuilder: (context, index) {
          final item = barcodeItems[index];
          return BarcodeCard(
            sourceImage: item.sourceImage?.buffer != null ? Image.memory(item.sourceImage!.buffer!) : null,
            format: item.format.toString(),
            text: item.text,
            extraWidget: GenericDocumentHelper.wrappedGenericDocumentField(item.extractedDocument),
          );
        },
      ),
    );
  }
}