import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

class BarcodeFormatsRepository {
  Set<BarcodeFormat> selectedFormats = getSelectableTypes().toSet();

  static List<BarcodeFormat> getSelectableTypes() =>
      PredefinedBarcodes.allBarcodeTypes();
}
