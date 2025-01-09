import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../snippets/_legacy/barcode_scanner_snippet.dart';
import '../snippets/_legacy/batch_barcode_scanner_snippet.dart';
import '../snippets/_legacy/qr_only_scanner_snippet.dart';

import '../utility/utils.dart';
import '../ui/menu_items.dart';
import '../ui/preview/_legacy_barcode_preview.dart';

import '../ui/_legacy_barcode_formats/repo.dart';
import '../ui/_legacy_barcode_formats/selector.dart';

class BarcodeLegacyUseCasesWidget extends StatefulWidget {
  @override
  _BarcodeLegacyUseCasesWidget createState() {
    return _BarcodeLegacyUseCasesWidget();
  }
}

class _BarcodeLegacyUseCasesWidget extends State<BarcodeLegacyUseCasesWidget> {
  late BarcodeFormatsRepository _barcodeFormatsRepository;

  @override
  void initState() {
    _barcodeFormatsRepository = BarcodeFormatsRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Legacy Scanners'),
        BuildMenuItem(context, 'Scan Barcode (all formats: 1D + 2D)', _startBarcodeScanner),
        BuildMenuItem(context, 'Scan QR code (QR format only)', _startQRScanner),
        BuildMenuItem(context, 'Scan Multiple Barcodes (batch mode)', _startBatchBarcodeScanner),
        MenuItemWidget(
            title: "Set Accepted Barcodes (legacy)",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        BarcodesFormatSelectorWidget(_barcodeFormatsRepository)),
              );
            },
          ),
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<BarcodeScanningResult> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var result = await scannerFunction();
      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result),
          ),
        );
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _startBarcodeScanner(BuildContext context) async {
    var configuration = barcodeConfigurationSnippet();
    configuration.barcodeFormats = _barcodeFormatsRepository.selectedFormats.toList();

    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotBarcodeSdk.startBarcodeScanner(configuration),
    );
  }

  Future<void> _startQRScanner(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotBarcodeSdk.startBarcodeScanner(QROnlyBarcodeConfigurationSnippet()),
    );
  }

  Future<void> _startBatchBarcodeScanner(BuildContext context) async {
    var configuration = batchBarcodeConfigurationSnippet();
    configuration.barcodeFormats = _barcodeFormatsRepository.selectedFormats.toList();

    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotBarcodeSdk.startBatchBarcodeScanner(configuration),
    );
  }
}