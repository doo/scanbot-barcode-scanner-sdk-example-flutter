import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

import '../../utility/generic_document_helper.dart';
import 'barcode_card.dart';

class MultiImageBarcodesResultPreviewWidget extends StatelessWidget {
  final List<BarcodeScannerResult> previewItems;

  const MultiImageBarcodesResultPreviewWidget(this.previewItems, {Key? key}) : super(key: key);

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
      body: ListView.builder(
        itemCount: previewItems.length,
        itemBuilder: (context, imageIndex) {
          final result = previewItems[imageIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const material.EdgeInsets.all(15),
                child: Text('Result ${imageIndex + 1}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              ...result.barcodes.map((barcode) => BarcodeCard(
                sourceImage: barcode.sourceImage?.buffer != null ? Image.memory(barcode.sourceImage!.buffer!) : null,
                format: barcode.format.toString(),
                text: barcode.text,
                extraWidget: GenericDocumentHelper.wrappedGenericDocumentField(barcode.extractedDocument),
              )),
            ],
          );
        },
      ),
    );
  }
}