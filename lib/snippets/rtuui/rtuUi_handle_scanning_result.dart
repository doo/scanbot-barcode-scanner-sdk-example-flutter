import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<List<BarcodeItem>> handleScanningResult() async {
  // Start the barcode RTU UI with default configuration
  final scanningResult = await ScanbotBarcodeSdk.barcode
      .startScanner(BarcodeScannerScreenConfiguration());

  // Check if the status returned is ok and that the data is present
  if (scanningResult is Ok<BarcodeScannerUiResult>) {
    // Extract the list of BarcodeItem from the scanning result
    final barcodes =
        scanningResult.value.items.map((item) => item.barcode).toList();

    return barcodes;
  } else if (scanningResult is Error<BarcodeScannerUiResult>) {
    // Handle the error here
    print(scanningResult.error.message);
  } else if (scanningResult is Cancel) {
    // Handle the cancellation here
  }
  return [];
}
