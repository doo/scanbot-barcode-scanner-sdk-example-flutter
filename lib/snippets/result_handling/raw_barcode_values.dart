import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<void> startScan() async {
  // Start the barcode RTU UI with default configuration
  final scanningResult = await ScanbotBarcodeSdk.barcode
      .startScanner(BarcodeScannerScreenConfiguration());

  switch (scanningResult) {
    case Ok():
      final mappedBarcodeItems = scanningResult.value.items.map((item) {
        final barcode = item.barcode;
        return {
          'format': barcode.format, // The format of the scanned barcode
          'textValue':
              barcode.text, // The value of the barcode represented as a string
          'rawValue': barcode.rawBytes, // The raw value of the barcode
          'document':
              barcode.extractedDocument, // The embedded barcode document
        };
      }).toList();

      print(mappedBarcodeItems);
    case Error():
      print(scanningResult.error.message);
    case Cancel():
      // Handle the cancellation here if needed
      print("Operation was canceled");
  }
  // });
}
