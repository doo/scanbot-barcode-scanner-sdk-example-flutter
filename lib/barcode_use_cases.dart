import 'package:flutter/material.dart';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

import '../snippets/rtuui/rtuUiV2_ar_overlay_usecase.dart';
import '../snippets/rtuui/rtuUiV2_find_and_pick_scanning_usecase.dart';
import '../snippets/rtuui/rtuUiV2_mapping_item_config.dart';
import '../snippets/rtuui/rtuUiV2_multi_scanning_usecase.dart';
import '../snippets/rtuui/rtuUiV2_single_scanning_usecase.dart';

import '../utility/utils.dart';
import '../ui/menu_item.dart';
import '../ui/preview/rtu_barcode_preview.dart';


class BarcodeUseCasesWidget extends StatefulWidget {
  @override
  _BarcodeUseCasesWidget createState() {
    return _BarcodeUseCasesWidget();
  }
}

class _BarcodeUseCasesWidget extends State<BarcodeUseCasesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Barcode Scanners (RTU)'),
        MenuItemWidget(title: "Single Scan with confirmation dialog", onTap: () => startSingleScanV2(context)),
        MenuItemWidget(title: "Multiple Scan", onTap: () => startMultipleScanV2(context)),
        MenuItemWidget(title: "Find and Pick", onTap: () => startFindAndPickScanV2(context)),
        MenuItemWidget(title: "AROverlay", onTap: () => startAROverlayScanV2(context)),
        MenuItemWidget(title: "Info Mapping", onTap: () => startItemMappingScanV2(context)),
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<ResultWrapper<BarcodeScannerUiResult>> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      /// if returnBarcodeImage = true, you must release it
      /// after using it, otherwise it will be leaked
      /// and you will get an error
      /// "ImageRef is not released"
      await autorelease(() async {
        var result = await scannerFunction();

        /// if you want to use image later call encodeImages() to save in buffer
        if(shouldReturnImageNotifier.value)
          result.data?.encodeImages();

        if (result.status == OperationStatus.OK &&
            result.data != null) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BarcodesUiResultPreviewWidget(result.data!),
            ),
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> startSingleScanV2(BuildContext context) async {
    var configuration = rtuUiV2SingleScanningUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();
    configuration.scannerConfiguration.returnBarcodeImage = shouldReturnImageNotifier.value;

    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdk.startBarcodeScanner(configuration),
    );
  }

  Future<void> startMultipleScanV2(BuildContext context) async {
    var configuration = rtuUiV2MultipleScanningUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();
    configuration.scannerConfiguration.returnBarcodeImage = shouldReturnImageNotifier.value;

    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdk.startBarcodeScanner(configuration),
    );
  }

  Future<void> startFindAndPickScanV2(BuildContext context) async {
    var configuration = rtuUiV2FindAndPickModeUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();
    configuration.scannerConfiguration.returnBarcodeImage = shouldReturnImageNotifier.value;

    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdk.startBarcodeScanner(configuration),
    );
  }

  Future<void> startAROverlayScanV2(BuildContext context) async {
    var configuration = rtuUiArOverlayUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();
    configuration.scannerConfiguration.returnBarcodeImage = shouldReturnImageNotifier.value;

    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdk.startBarcodeScanner(configuration),
    );
  }

  Future<void> startItemMappingScanV2(BuildContext context) async {
    var configuration = rtuUiV2MappingItemConfiguration();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();
    configuration.scannerConfiguration.returnBarcodeImage = shouldReturnImageNotifier.value;

    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdk.startBarcodeScanner(configuration),
    );
  }
}