import 'dart:io';

import 'package:flutter/material.dart';

import 'package:barcode_scanner/barcode_scanning_data.dart';

import 'package:scanbot_barcode_sdk_example/ui/barcode_item.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  BarcodeScanningResult preview;

  BarcodesResultPreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text('Scanned barcodes',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: Column(
          children: <Widget>[
            getImageContainer(preview.barcodeImageURI),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  return BarcodeItemWidget(preview.barcodeItems[position]);
                },
                itemCount: preview.barcodeItems.length,
              ),
            ),
          ],
        ));
  }

  Widget getImageContainer(Uri imageUri) {
    if (preview.barcodeImageURI == null) {
      return Container();
    }
    var file = File.fromUri(imageUri);
    if (file?.existsSync() == true) {
      return Container(
          child: Center(
        child: Image.file(
          file,
          height: 200,
          width: double.infinity,
        ),
      ));
    }
    return Container();
  }
}
