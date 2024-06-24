import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as sdk;
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as scanbot;
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

import '../../main.dart';

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
           // showPolygon: showPolygon,
            onScanned: (String barcode) async {
              print('Barcode: $barcode scanned');
              // if the barcode is in our inventory and is a valid product, timeout for mocking network call
              Future<void>.delayed(const Duration(milliseconds: 300));

              detectBarcodes.value = false;
              setState(() {
                _index = 0; // to change a value inside setState this a more correct approach?
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
      {required this.detectBarcodes, required this.onScanned, required this.onLicenseFailed});

  final ValueNotifier<bool> detectBarcodes;
  final Future<dynamic> Function(String) onScanned;
  final void Function() onLicenseFailed;

  @override
  State<ScanbotScanner> createState() => _ScanbotScannerState();
}

class _ScanbotScannerState extends State<ScanbotScanner> with WidgetsBindingObserver {
  Timer? _lastScanTimer;
  bool _cameraPreviewStarted = false;
  bool _shouldScan = false;
  bool _isRunningAdd = false;
  bool _cameraBreak = false;
  String _lastScannedBarcode = '';
  DateTime _lastScannedTime = DateTime.now();
  DateTime _detectBarcodesTimeLastChanged = DateTime.now();
  final int _delayUntilAdd = 100;
  final int _delayUntilShowCameraAfterPreviewStarted = 100;
  final int _turnOffCameraWhenIdleFor = 3000;
  final bool _shouldScanAllTypesOfBarcodes = false;
  final bool _showCameraOverlay = true;
  bool _showBarcodeOverlay = true;

  var BARCODE_SDK_LICENSE_KEY = "I+MTYRjgxBo4xpGqu32CafPylHNvVK" +
      "upQLtwyu4IBf4RtChRH6+zH+uB4Xwg" +
      "/etnl8A3e9w34oApfvgoVT0uUntsH6" +
      "0z2ZmSAMugTlwZJDDP0K4LLP6XKoMW" +
      "b9v7x+i6M29bSMo8WQqwosOnfaI4ON" +
      "y9vrhCqvrN9qx4lIK3TwqkVcxa5hAI" +
      "Hecsct+YIy0wwrLiXcWc5tJb8Kc9iB" +
      "7I2MxoG/7k0CCsv14LY48D+Cm/uLLz" +
      "NSG8aIcYqOXAC9PimxQKcaOqwiP2bV" +
      "L7Y66cmdnEhD1907OuLyAaAZ87DDH0" +
      "heHfkkZ+hvNtRB15lAmzrXplWJOgX6" +
      "Uu/ipnLc+z7Q==\nU2NhbmJvdFNESw" +
      "pkb28uc2NhbmJvdC5jYXBhY2l0b3Iu" +
      "ZXhhbXBsZXxpby5zY2FuYm90LmV4YW" +
      "1wbGUuZmx1dHRlcnxpby5zY2FuYm90" +
      "LmV4YW1wbGUuc2RrLmFuZHJvaWR8aW" +
      "8uc2NhbmJvdC5leGFtcGxlLnNkay5i" +
      "YXJjb2RlLmFuZHJvaWR8aW8uc2Nhbm" +
      "JvdC5leGFtcGxlLnNkay5iYXJjb2Rl" +
      "LmNhcGFjaXRvcnxpby5zY2FuYm90Lm" +
      "V4YW1wbGUuc2RrLmJhcmNvZGUuZmx1" +
      "dHRlcnxpby5zY2FuYm90LmV4YW1wbG" +
      "Uuc2RrLmJhcmNvZGUuaW9uaWN8aW8u" +
      "c2NhbmJvdC5leGFtcGxlLnNkay5iYX" +
      "Jjb2RlLm1hdWl8aW8uc2NhbmJvdC5l" +
      "eGFtcGxlLnNkay5iYXJjb2RlLm5ldH" +
      "xpby5zY2FuYm90LmV4YW1wbGUuc2Rr" +
      "LmJhcmNvZGUucmVhY3RuYXRpdmV8aW" +
      "8uc2NhbmJvdC5leGFtcGxlLnNkay5i" +
      "YXJjb2RlLndpbmRvd3N8aW8uc2Nhbm" +
      "JvdC5leGFtcGxlLnNkay5iYXJjb2Rl" +
      "LnhhbWFyaW58aW8uc2NhbmJvdC5leG" +
      "FtcGxlLnNkay5iYXJjb2RlLnhhbWFy" +
      "aW4uZm9ybXN8aW8uc2NhbmJvdC5leG" +
      "FtcGxlLnNkay5jYXBhY2l0b3J8aW8u" +
      "c2NhbmJvdC5leGFtcGxlLnNkay5jYX" +
      "BhY2l0b3IuYW5ndWxhcnxpby5zY2Fu" +
      "Ym90LmV4YW1wbGUuc2RrLmNhcGFjaX" +
      "Rvci5pb25pY3xpby5zY2FuYm90LmV4" +
      "YW1wbGUuc2RrLmNhcGFjaXRvci5pb2" +
      "5pYy5yZWFjdHxpby5zY2FuYm90LmV4" +
      "YW1wbGUuc2RrLmNhcGFjaXRvci5pb2" +
      "5pYy52dWVqc3xpby5zY2FuYm90LmV4" +
      "YW1wbGUuc2RrLmNvcmRvdmEuaW9uaW" +
      "N8aW8uc2NhbmJvdC5leGFtcGxlLnNk" +
      "ay5mbHV0dGVyfGlvLnNjYW5ib3QuZX" +
      "hhbXBsZS5zZGsuaW9zLmJhcmNvZGV8" +
      "aW8uc2NhbmJvdC5leGFtcGxlLnNkay" +
      "5pb3MuY2xhc3NpY3xpby5zY2FuYm90" +
      "LmV4YW1wbGUuc2RrLmlvcy5ydHV1aX" +
      "xpby5zY2FuYm90LmV4YW1wbGUuc2Rr" +
      "Lm1hdWl8aW8uc2NhbmJvdC5leGFtcG" +
      "xlLnNkay5tYXVpLnJ0dXxpby5zY2Fu" +
      "Ym90LmV4YW1wbGUuc2RrLm5ldHxpby" +
      "5zY2FuYm90LmV4YW1wbGUuc2RrLnJl" +
      "YWN0bmF0aXZlfGlvLnNjYW5ib3QuZX" +
      "hhbXBsZS5zZGsucmVhY3QubmF0aXZl" +
      "fGlvLnNjYW5ib3QuZXhhbXBsZS5zZG" +
      "sucnR1LmFuZHJvaWR8aW8uc2NhbmJv" +
      "dC5leGFtcGxlLnNkay54YW1hcmlufG" +
      "lvLnNjYW5ib3QuZXhhbXBsZS5zZGsu" +
      "eGFtYXJpbi5mb3Jtc3xpby5zY2FuYm" +
      "90LmV4YW1wbGUuc2RrLnhhbWFyaW4u" +
      "cnR1fGlvLnNjYW5ib3QuZm9ybXMubm" +
      "F0aXZlcmVuZGVyZXJzLmV4YW1wbGV8" +
      "aW8uc2NhbmJvdC5uYXRpdmViYXJjb2" +
      "Rlc2RrcmVuZGVyZXJ8aW8uc2NhbmJv" +
      "dC5TY2FuYm90U0RLU3dpZnRVSURlbW" +
      "98aW8uc2NhbmJvdC5zZGtfd3JhcHBl" +
      "ci5kZW1vLmJhcmNvZGV8aW8uc2Nhbm" +
      "JvdC5zZGstd3JhcHBlci5kZW1vLmJh" +
      "cmNvZGV8aW8uc2NhbmJvdC5zZGsuaW" +
      "50ZXJuYWxkZW1vfGxvY2FsaG9zdHxP" +
      "cGVyYXRpbmdTeXN0ZW1TdGFuZGFsb2" +
      "5lfHNjYW5ib3RzZGstcWEtMS5zMy1l" +
      "dS13ZXN0LTEuYW1hem9uYXdzLmNvbX" +
      "xzY2FuYm90c2RrLXFhLTIuczMtZXUt" +
      "d2VzdC0xLmFtYXpvbmF3cy5jb218c2" +
      "NhbmJvdHNkay1xYS0zLnMzLWV1LXdl" +
      "c3QtMS5hbWF6b25hd3MuY29tfHNjYW" +
      "5ib3RzZGstcWEtNC5zMy1ldS13ZXN0" +
      "LTEuYW1hem9uYXdzLmNvbXxzY2FuYm" +
      "90c2RrLXFhLTUuczMtZXUtd2VzdC0x" +
      "LmFtYXpvbmF3cy5jb218c2NhbmJvdH" +
      "Nkay13YXNtLWRlYnVnaG9zdC5zMy1l" +
      "dS13ZXN0LTEuYW1hem9uYXdzLmNvbX" +
      "x3ZWJzZGstZGVtby1pbnRlcm5hbC5z" +
      "Y2FuYm90LmlvfCoucWEuc2NhbmJvdC" +
      "5pbwoxNzE5ODc4Mzk5CjgzODg2MDcK" +
      "MzE=\n";

  _initScanbotSdk() async {
    Directory? storageDirectory;
    if (Platform.isAndroid) {
      storageDirectory = await getExternalStorageDirectory();
    }
    if (Platform.isIOS) {
      storageDirectory = await getApplicationDocumentsDirectory();
    }
    EncryptionParameters? encryptionParameters;
    if (shouldInitWithEncryption) {
      encryptionParameters = EncryptionParameters(
          password: "password", mode: FileEncryptionMode.AES256);
    }
    var config = ScanbotSdkConfig(
        licenseKey: BARCODE_SDK_LICENSE_KEY,
        encryptionParameters: encryptionParameters,
        loggingEnabled: true,
        // Consider disabling logging in production builds for security and performance reasons.
        storageBaseDirectory:
        "${storageDirectory?.path}/custom-barcode-sdk-storage");

    try {
      config.useCameraX = true;
      await ScanbotBarcodeSdk.initScanbotSdk(config);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _shouldScan = widget.detectBarcodes.value;
    widget.detectBarcodes.addListener(_onDetectBarcodeChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lastScanTimer?.cancel();
    widget.detectBarcodes.removeListener(_onDetectBarcodeChange);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraPreviewStarted = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ScanbotScanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.detectBarcodes != widget.detectBarcodes) {
      oldWidget.detectBarcodes.removeListener(_onDetectBarcodeChange);
      widget.detectBarcodes.addListener(_onDetectBarcodeChange);
    }
  }

  void _startScanTimer() {
    _lastScanTimer?.cancel();
    _lastScanTimer = Timer(Duration(milliseconds: _turnOffCameraWhenIdleFor), () {
      if (_cameraBreak && !_cameraPreviewStarted) return;
      _cameraBreak = true;
      _cameraPreviewStarted = false;
      if (mounted) setState(() {});
    });
  }

  void _cancelScanTimer() {
    _lastScanTimer?.cancel();
    if (!_cameraBreak) return;
    _cameraBreak = false;
    if (mounted) setState(() {});
  }

  void _changeDetection(bool detect) {
    detect ? _cancelScanTimer() : _startScanTimer();
    if (_shouldScan != detect) {
      _shouldScan = detect;
      if (mounted) setState(() {});
    }
  }

  Future<void> _addBarcodeItem(List<sdk.BarcodeItem> barcodeItems) async {
    if (_isRunningAdd ||
        !_cameraPreviewStarted ||
        !DateTime.now().isAfter(_detectBarcodesTimeLastChanged.add(Duration(milliseconds: _delayUntilAdd)))) return;
    _isRunningAdd = true;
    sdk.BarcodeItem? barcodeItem = barcodeItems.firstWhereOrNull((sdk.BarcodeItem item) {
      String barcode = item.text ?? '';
      return barcode.isNotEmpty &&
          (barcode == _lastScannedBarcode
              ? DateTime.now().difference(_lastScannedTime) > const Duration(seconds: 1)
              : true) &&
          !barcode.startsWith('{') &&
          !barcode.contains('http') &&
          (item.barcodeFormat == sdk.BarcodeFormat.DATA_MATRIX
              ? barcode.length == 27 && barcode.substring(1, 3) == '01' && barcode.substring(19, 21) == '98'
              : true);
    });

    dynamic result;
    String barcode = barcodeItem?.text ?? '';
    if (barcode.isNotEmpty) {
      _lastScannedBarcode = barcode;
      _lastScannedTime = DateTime.now();
      result = await widget.onScanned(barcode);
    }
    if (result == 200 || result == 404) {
      _changeDetection(false);
    }
    _isRunningAdd = false;
  }

  void _onDetectBarcodeChange() {
    if (_shouldScan != widget.detectBarcodes.value) {
      _detectBarcodesTimeLastChanged = DateTime.now();
      _changeDetection(widget.detectBarcodes.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          if (!_cameraBreak)
            sdk.BarcodeScannerCamera(
                barcodeListener: (sdk.BarcodeScanningResult scanningResult) async {
                  await _addBarcodeItem(scanningResult.barcodeItems);
                },
                errorListener: (sdk.SdkLicenseException e) {
                  print('Error: ${e.message}');
                  widget.onLicenseFailed();
                },
                onCameraPreviewStarted: (bool _) {
                  _changeDetection(false);
                  Future.delayed(Duration(milliseconds: _delayUntilShowCameraAfterPreviewStarted), () {
                    _cameraPreviewStarted = true;
                    if (mounted) setState(() {});
                    if (widget.detectBarcodes.value) {
                      _changeDetection(true);
                    }
                  });
                },
                configuration: sdk.BarcodeCameraConfiguration(
                  detectionEnabled: _shouldScan,
                  scannerConfiguration: sdk.BarcodeClassicScannerConfiguration(
                    barcodeFormats: _shouldScanAllTypesOfBarcodes
                        ? sdk.PredefinedBarcodes.allBarcodeTypes()
                        : [
                      sdk.BarcodeFormat.EAN_8,
                      sdk.BarcodeFormat.EAN_13,
                      sdk.BarcodeFormat.CODE_128,
                      sdk.BarcodeFormat.DATA_MATRIX,
                      sdk.BarcodeFormat.DATABAR_LIMITED,
                      sdk.BarcodeFormat.RSS_14,
                      sdk.BarcodeFormat.RSS_EXPANDED,
                      sdk.BarcodeFormat.GS1_COMPOSITE,
                      sdk.BarcodeFormat.UPC_A,
                      sdk.BarcodeFormat.UPC_E,
                    ],
                    acceptedDocumentFormats: [],
                    additionalParameters: sdk.BarcodeAdditionalParameters(
                      gs1HandlingMode: sdk.Gs1HandlingMode.DECODE,
                      msiPlesseyChecksumAlgorithm: sdk.MSIPlesseyChecksumAlgorithm.MOD_11_NCR,
                    ),
                  ),
                  finder: !_showCameraOverlay
                      ? null
                      : sdk.FinderConfiguration(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.yellow,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                      ),
                      widget: LayoutBuilder(builder: (context, constrains) {
                        double boxSize = (constrains.maxHeight / 6).floor().toDouble();
                        return OverflowBox(
                          maxHeight: constrains.maxHeight + 16,
                          maxWidth: constrains.maxWidth + 16,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      top: BorderSide(width: 2, color: Colors.yellow),
                                      right: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 2, color: Colors.yellow),
                                      left: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 2, color: Colors.yellow),
                                      right: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 2, color: Colors.yellow),
                                      left: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      backgroundColor: Colors.black.withOpacity(0.4),
                      finderInsets: const sdk.Insets(bottom: 100),
                      finderAspectRatio: sdk.AspectRatio(width: 3, height: 2.2)),
                  cameraZoomFactor: 0.02,
                  overlayConfiguration: sdk.SelectionOverlayScannerConfiguration(
                    overlayEnabled: _shouldScan && _showBarcodeOverlay,
                    automaticSelectionEnabled: true,
                    textFormat: sdk.BarcodeOverlayTextFormat.NONE,
                    polygonColor: Colors.yellow,
                  ),
                )),
          if (!_cameraPreviewStarted)
            Container(
                color: Colors.black,
                child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 2,
                    ))),
        ],
      ),
    );
  }
}