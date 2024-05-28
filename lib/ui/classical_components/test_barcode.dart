import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as sdk;

class ScanbotScannerScreen extends StatefulWidget {
  const ScanbotScannerScreen();

  @override
  State<ScanbotScannerScreen> createState() => _ScanbotScannerScreenState();
}

class _ScanbotScannerScreenState extends State<ScanbotScannerScreen> {
  int _index = 0;
  ValueNotifier<bool> detectBarcodes = ValueNotifier<bool>(false);
  ValueNotifier<bool> showPolygon = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScanbotScanner(
            detectBarcodes: detectBarcodes,
            showPolygon: showPolygon,
            onScanned: (String barcode) async {
              print('Barcode: $barcode scanned');
              // if the barcode is in our inventory and is a valid product, timeout for mocking network call
              Future<void>.delayed(const Duration(milliseconds: 300));

              detectBarcodes.value = false;
              setState(() {
                _index =
                    0; // to change a value inside setState this a more correct approach?
              });
              return 200;
            },
            onLicenseFailed: () {
              print('License failed');
            }),
        IndexedStack(
          index: _index,
          children: [
            GestureDetector(
              onTap: () {
                detectBarcodes.value = true;
                setState(() {
                  _index =
                      1; // to change a value inside setState this a more correct approach?
                });
              },
              child: Container(
                  color: Colors.green,
                  child: const Center(child: Text('Start scanning'))),
            ),
            Container(color: Colors.transparent)
          ],
        ),
      ],
    );
  }
}

class ScanbotScanner extends StatefulWidget {
  const ScanbotScanner(
      {required this.detectBarcodes,
      required this.showPolygon,
      required this.onScanned,
      required this.onLicenseFailed});

  final ValueNotifier<bool> detectBarcodes;
  final ValueNotifier<bool> showPolygon;
  final Future<int> Function(String) onScanned;
  final void Function() onLicenseFailed;

  @override
  State<ScanbotScanner> createState() => _ScanbotScannerState();
}

class _ScanbotScannerState extends State<ScanbotScanner> {
  bool _validLicense = true;
  bool _detectionEnabled = true;
  bool _showPolygon = true;

  @override
  void initState() {
    super.initState();
    _initScanbotSdk();
    widget.detectBarcodes.addListener(_onDetectBarcodeChange);
  }

  @override
  void dispose() {
    widget.detectBarcodes.removeListener(_onDetectBarcodeChange);
    super.dispose();
  }

  Future<void> _addBarcodeItem(List<sdk.BarcodeItem> barcodeItems) async {
    sdk.BarcodeItem? barcodeItem =
        barcodeItems.firstWhereOrNull((sdk.BarcodeItem item) {
      String barcode = item.text ?? '';
      return barcode.isNotEmpty &&
          !barcode.startsWith('{') &&
          !barcode.contains('http') &&
          (item.barcodeFormat == sdk.BarcodeFormat.DATA_MATRIX
              ? barcode.length == 27 &&
                  barcode.substring(1, 3) == '01' &&
                  barcode.substring(19, 21) == '98'
              : true);
    });

    int result;
    String barcode = barcodeItem?.text ?? '';
    if (barcode.isEmpty) {
      return;
    } else {
      setState(() {
        _detectionEnabled = false;
      });
      ;
      result = await widget.onScanned(barcode);
    }

    if (result == 307) {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (widget.detectBarcodes.value) {
        setState(() {
          _detectionEnabled = true;
        });
      }
    }
  }

  void _onDetectBarcodeChange() {
    setState(() {
      _detectionEnabled = widget.detectBarcodes.value;
    });
  }

  Future<void> _initScanbotSdk() async {
    try {
      // String licenseKey = 'YOUR_SCANBOT_SDK_LICENSE_KEY_HERE';
      // sdk.ScanbotSdkConfig config = sdk.ScanbotSdkConfig(licenseKey: licenseKey, useCameraX: true);
      // await sdk.ScanbotSdk.initScanbotSdk(config);
      setState(() {
        _validLicense = true;
      });
    } catch (e) {
      widget.onLicenseFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _barcodeCameraConfiguration = sdk.BarcodeCameraConfiguration(
      detectionEnabled: _detectionEnabled,
      scannerConfiguration: sdk.BarcodeClassicScannerConfiguration(
        barcodeFormats: [
          sdk.BarcodeFormat.EAN_8,
          sdk.BarcodeFormat.EAN_13,
          sdk.BarcodeFormat.CODE_128,
          sdk.BarcodeFormat.DATA_MATRIX,
          sdk.BarcodeFormat.DATABAR_LIMITED,
          // sdk.BarcodeFormat.RSS_14,
          // sdk.BarcodeFormat.RSS_EXPANDED,
          sdk.BarcodeFormat.GS1_COMPOSITE,
          sdk.BarcodeFormat.UPC_A,
          sdk.BarcodeFormat.UPC_E,
        ],
        acceptedDocumentFormats: [],
        additionalParameters: sdk.BarcodeAdditionalParameters(
          gs1HandlingMode: sdk.Gs1HandlingMode.DECODE,
          msiPlesseyChecksumAlgorithm:
              sdk.MSIPlesseyChecksumAlgorithm.MOD_11_NCR,
        ),
      ),
      finder: sdk.FinderConfiguration(
          decoration: BoxDecoration(
              border: Border.all(
                width: 5,
                color: Colors.blue,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          backgroundColor: Colors.grey.withOpacity(0.5),
          finderInsets: const sdk.Insets(bottom: 100),
          finderAspectRatio: sdk.AspectRatio(width: 3, height: 2.2)),
      cameraZoomFactor: 0,
      // this makes it only possible to scan one barcode or user has to click on the barcode to select it (which is not good ux for our solution)

      overlayConfiguration: sdk.SelectionOverlayScannerConfiguration(
        overlayEnabled: _showPolygon,
        automaticSelectionEnabled: false,
        textFormat: sdk.BarcodeOverlayTextFormat.NONE,
        polygonColor: Colors.green,
        textColor: Colors.black,
        textContainerColor: Colors.white,
      ),
    );

    return Container(
      color: Colors.grey,
      child: _validLicense
          ? sdk.BarcodeScannerCamera(
              configuration: _barcodeCameraConfiguration,
              barcodeListener:
                  (sdk.BarcodeScanningResult scanningResult) async {
                _addBarcodeItem(scanningResult.barcodeItems);
              },
              // Will inform if there is problem with the license on opening of the screen // and license expiration on android, ios wil be enabled a bit later
              errorListener: (error) {
                widget.onLicenseFailed();
              },
              onCameraPreviewStarted: (isFlashEnabled) {},
              onHeavyOperationProcessing: (bool heavyOperationInProgress) {},
            )
          : Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Villa við að virkja skanna',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}
