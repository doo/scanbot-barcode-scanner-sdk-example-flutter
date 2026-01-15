import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

import '../../utility/generic_document_helper.dart';
import '../../utility/utils.dart';
import 'barcode_card.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  final List<BarcodeItem> previewItems;

  const BarcodesResultPreviewWidget(this.previewItems, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Scanned barcodes',
          showBackButton: true, context: context),
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
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              BarcodeCard(
                sourceImage: result.sourceImage?.buffer != null
                    ? Image.memory(result.sourceImage!.buffer!)
                    : null,
                format: result.format.name,
                text: result.text + " " + result.upcEanExtension,
                extraWidget: GenericDocumentHelper.wrappedGenericDocumentField(
                    result.extractedDocument),
              ),
            ],
          );
        },
      ),
    );
  }
}
