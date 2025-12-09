import 'package:barcode_scanner/barcode_sdk.dart';

Future<List<BarcodeItem>> handleScanningResult() async {
  // Start the barcode RTU UI with default configuration
  final scanningResult = await ScanbotBarcodeSdk.barcode
      .startScanner(BarcodeScannerScreenConfiguration());

  // Check if the status returned is ok and that the data is present
  if (scanningResult.status == OperationStatus.OK &&
      scanningResult.data != null) {
    // Extract the list of BarcodeItem from the scanning result
    final barcodes =
        scanningResult.data!.items.map((item) => item.barcode).toList();

    return barcodes;
  }
  return [];
}
