import 'package:barcode_scanner/barcode_scanning_data.dart';
import 'package:flutter/material.dart';

class BarcodeItemWidget extends StatelessWidget {
  final BarcodeItem item;

  BarcodeItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              barcodeFormatEnumMap[item.barcodeFormat]!,
              style: const TextStyle(inherit: true, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.text ?? "",
                style: const TextStyle(inherit: true, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

const barcodeFormatEnumMap = {
  BarcodeFormat.AZTEC: 'AZTEC',
  BarcodeFormat.CODABAR: 'CODABAR',
  BarcodeFormat.CODE_39: 'CODE_39',
  BarcodeFormat.CODE_93: 'CODE_93',
  BarcodeFormat.CODE_128: 'CODE_128',
  BarcodeFormat.DATA_MATRIX: 'DATA_MATRIX',
  BarcodeFormat.EAN_8: 'EAN_8',
  BarcodeFormat.EAN_13: 'EAN_13',
  BarcodeFormat.ITF: 'ITF',
  BarcodeFormat.PDF_417: 'PDF_417',
  BarcodeFormat.QR_CODE: 'QR_CODE',
  BarcodeFormat.RSS_14: 'RSS_14',
  BarcodeFormat.RSS_EXPANDED: 'RSS_EXPANDED',
  BarcodeFormat.UPC_A: 'UPC_A',
  BarcodeFormat.UPC_E: 'UPC_E',
  BarcodeFormat.MSI_PLESSEY: 'MSI_PLESSEY',
  BarcodeFormat.UNKNOWN: 'UNKNOWN',
};
