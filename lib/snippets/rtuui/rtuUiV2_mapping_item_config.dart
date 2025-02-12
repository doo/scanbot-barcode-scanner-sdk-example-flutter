import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration rtuUiV2MappingItemConfiguration() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Initialize the use case for single scanning.
  var scanningMode = MultipleScanningMode();

  // Set the item mapper.
  scanningMode.barcodeInfoMapping.barcodeItemMapper =
      (item, onResult, onError) async {
    /** TODO: process scan result as needed to get your mapped data,
         * e.g. query your server to get product image, title and subtitle.
         * See example below.
         */
    var title = "Some product ${item.textWithExtension}";
    var subtitle = item.type?.name ?? "Unknown";
    var image =
        "https://avatars.githubusercontent.com/u/1454920";

    /** TODO: call [onError()] in case of error during obtaining mapped data. */
    if (item.textWithExtension == "Error occurred!") {
      onError();
    } else {
      onResult(BarcodeMappedData(
        title: title,
        subtitle: subtitle,
        barcodeImage: image,
      ));
    }
  };

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.

  return configuration;
}
