import 'package:flutter/material.dart';
import 'package:barcode_scanner/barcode_scanning_data.dart';

class BarcodeFormatItemWidget extends StatelessWidget {
  BarcodeFormat format;
  bool selected;
  ValueChanged<bool?> onSelect;

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
                  barcodeFormatEnumMap[format]!,
                  style: TextStyle(inherit: true, color: Colors.black),
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
};
