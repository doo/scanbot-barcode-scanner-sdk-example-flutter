import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:barcode_scanner/barcode_scanning_data.dart';
import 'package:barcode_scanner/scanbot_encryption_handler.dart';

import 'package:scanbot_barcode_sdk_example/ui/ready_to_use_ui(legacy)/barcode_item.dart';
import '../../main.dart' show shouldInitWithEncryption;

class BarcodesResultPreviewWidget extends StatelessWidget {
  final BarcodeScanningResult preview;

  BarcodesResultPreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    Widget _buildPreviewView() {
      var barcodeImageURI = preview.barcodeImageURI;
      if (barcodeImageURI != null) {
        return shouldInitWithEncryption
            ? EncryptedPageWidget(barcodeImageURI)
            : PageWidget(barcodeImageURI);
      } else {
        return Container();
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Scanned barcodes',
          style: TextStyle(inherit: true, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildPreviewView(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                return BarcodeItemWidget(preview.barcodeItems[position]);
              },
              itemCount: preview.barcodeItems.length,
            ),
          ),
        ],
      ),
    );
  }
}

class EncryptedPageWidget extends StatelessWidget {
  final Uri path;

  EncryptedPageWidget(this.path);

  Future<Uint8List> _getDecryptedImageData() {
    return ScanbotEncryptionHandler.getDecryptedDataFromFile(path);
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageWidget(
      future: _getDecryptedImageData(),
    );
  }
}

class PageWidget extends StatelessWidget {
  final Uri path;

  PageWidget(this.path);

  Uint8List _getImageData() {
    var file = File.fromUri(path);
    return file.readAsBytesSync();
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageWidget(
      future: Future.value(_getImageData()),
    );
  }
}

Widget _buildImageWidget({required Future<Uint8List> future}) {
  return SizedBox(
    height: 200,
    width: double.infinity,
    child: FutureBuilder<Uint8List>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Center(child: Image.memory(snapshot.data!));
        } else {
          return Container();
        }
      },
    ),
  );
}
