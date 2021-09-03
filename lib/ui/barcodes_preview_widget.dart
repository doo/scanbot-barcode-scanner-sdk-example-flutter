import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:barcode_scanner/barcode_scanning_data.dart';
import 'package:barcode_scanner/scanbot_encryption_handler.dart';

import 'package:scanbot_barcode_sdk_example/ui/barcode_item.dart';
import '../main.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  BarcodeScanningResult preview;

  BarcodesResultPreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    Widget previewView;
    var barcodeImageURI = preview.barcodeImageURI;
    if (barcodeImageURI != null) {
      if (shouldInitWithEncryption) {
        previewView = EncryptedPageWidget(barcodeImageURI);
      } else {
        previewView = PageWidget(barcodeImageURI);
      }
    } else {
      previewView = Container();
    }
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
            previewView,
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

}

class EncryptedPageWidget extends StatelessWidget {
  final Uri path;

  EncryptedPageWidget(this.path);

  @override
  Widget build(BuildContext context) {
    var imageData = ScanbotEncryptionHandler.getDecryptedDataFromFile(path);
    return Container(
        height: 200,
        width: double.infinity,
        child: FutureBuilder(
            future: imageData,
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              var data = snapshot.data;
              if (data != null) {
                Image image = Image.memory(data);
                return Center(child: image);
              } else {
                return Container();
              }
            }));
  }
}

class PageWidget extends StatelessWidget {
  final Uri path;

  PageWidget(this.path);

  @override
  Widget build(BuildContext context) {
    var file = File.fromUri(path);
    var bytes = file.readAsBytesSync();
    //should be this one after fixing https://github.com/flutter/flutter/issues/17419
    //
    // var image = Image.file(
    //    file,
    //   height: double.infinity,
    //    width: double.infinity,
    // );
    Image image = Image.memory(bytes);
    return Container(
      height: 200,
      width: double.infinity,
      child: Center(child: image),
    );
  }
}

