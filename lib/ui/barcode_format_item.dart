import 'package:barcode_scanner/json/common_data.dart';
import 'package:flutter/material.dart';

class BarcodeFormatItemWidget extends StatelessWidget {
  final BarcodeFormat format;
  final bool selected;
  final ValueChanged<bool?> onSelect;

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
                  style: const TextStyle(inherit: true, color: Colors.black),
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
    BarcodeFormat.IATA_2_OF_5: 'IATA_2_OF_5',
    BarcodeFormat.INDUSTRIAL_2_OF_5: 'INDUSTRIAL_2_OF_5',
    BarcodeFormat.CODE_25: 'CODE_25',
    BarcodeFormat.UNKNOWN: 'UNKNOWN',
};
