import 'dart:async';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as scanbot;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_barcode_sdk_example/ui/barcodes_preview_widget.dart';

import '../../main.dart';

// This is an example screen of how to integrate the new classical barcode scanner component
class BarcodeScannerWidget extends StatefulWidget {
  const BarcodeScannerWidget({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  // this stream is only used if you need to show live scanned results on top of the camera
  // otherwise we stop scanning and return the first result
  final resultStream = StreamController<BarcodeScanningResult>();
  ScanbotCameraController? controller;
  late BarcodeCameraLiveDetector barcodeCameraDetector;
  bool permissionGranted = false;
  bool flashEnabled = true;
  bool flashAvailable = false;
  bool showProgressBar = false;
  bool licenseIsActive = true;

  _BarcodeScannerWidgetState() {
    barcodeCameraDetector = BarcodeCameraLiveDetector(
      // Subscribe to the success result of the scanning end error handling
      barcodeListener: (scanningResult) {
        // Use update function to show result overlay on top of the camera or
        //resultStream.add(scanningResult);

        // this to return result to screen caller
        barcodeCameraDetector
            .pauseDetection(); // we can also pause detection immediately after success to prevent it from sending new sucсess results
        Navigator.pop(context, scanningResult);

        print(scanningResult.toJson().toString());
      },
      // Error listener will inform if there is a problem with the license on opening the screen
      // and license expiration on Android (will be enabled a bit later on iOS)
      errorListener: (error) {
        setState(() {
          licenseIsActive = false;
        });
        Logger.root.severe(error.toString());
      },
    );
  }

  void checkPermission() async {
    // Don't forget to update the iOS Podfile according to the `permission_handler` official installation guide!! https://pub.dev/packages/permission_handler
    final permissionResult = await [Permission.camera].request();
    setState(() {
      permissionGranted =
          permissionResult[Permission.camera]?.isGranted ?? false;
    });
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var finderConfiguration = FinderConfiguration(
        onFinderRectChange: (left, top, right, bottom) {
          // aligning some text view to the finder dynamically by calculating its position from finder changes
        },
        // a widget that can be inserted in the region between the finder hole and the top of the camera view
        topWidget: const Center(
            child: Text(
          'Top hint text, centre aligned',
          style: TextStyle(color: Colors.white),
        )),
        // a widget that can be inserted in the region between the finder hole and the bottom of the camera view
        bottomWidget: const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'This is text below the finder, top-center aligned',
              style: TextStyle(color: Colors.white),
            )),
        // a widget that can be inserted inside the finder window
        widget: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.lightBlue.withAlpha(155),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
          ),
        ),
        // The shape by which the background will be clipped and which will be presented as the finder hole
        decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.deepPurple,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        backgroundColor: Colors.amber.withAlpha(150),
        finderAspectRatio: scanbot.AspectRatio(width: 5, height: 2));

    var barcodeClassicScannerConfiguration = BarcodeClassicScannerConfiguration(
      barcodeFormats: barcodeFormatsRepository.selectedFormats.toList(),
      // [BarcodeFormat.QR_CODE] for one barcode type
      engineMode: EngineMode.NEXT_GEN,
      additionalParameters: BarcodeAdditionalParameters(
          msiPlesseyChecksumAlgorithm: MSIPlesseyChecksumAlgorithm.MOD_11_NCR,
          gs1HandlingMode: Gs1HandlingMode.NONE),
      // get the full size image of the document with a successfully scanned barcode
      // barcodeImageGenerationType: BarcodeImageGenerationType.CAPTURED_IMAGE
    );

    var barcodeCameraConfiguration = BarcodeCameraConfiguration(
      flashEnabled: flashEnabled, // initial flash state
      // Initial configuration for the scanner itself
      overlayConfiguration:
          SelectionOverlayScannerConfiguration(overlayEnabled: true),
      scannerConfiguration: barcodeClassicScannerConfiguration,
      finder: finderConfiguration,
    );
    
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Scan barcodes',
          style: TextStyle(
            inherit: true,
            color: Colors.black,
          ),
        ),
        actions: [
          if (flashAvailable)
            IconButton(
                onPressed: () {
                  controller?.setFlashEnabled(!flashEnabled).then((value) => {
                        setState(() {
                          flashEnabled = !flashEnabled;
                        })
                      });
                },
                icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            // Check permission and show a placeholder if it's not granted, otherwise show the camera

            licenseIsActive
                ? permissionGranted
                    ? BarcodeScannerCamera(
                        cameraDetector: barcodeCameraDetector,
                        // Camera on the bottom of the stack, should not be rebuilt on each update of the stateful widget
                        configuration: barcodeCameraConfiguration,
                        onWidgetReady: (controller) {
                          // Once your camera has initialized, you are able to control the camera parameters
                          this.controller = controller;
                          // This option checks whether the flash is available and whether a control button is displayed
                          controller.isFlashAvailable().then((value) => {
                                setState(() {
                                  flashAvailable = value;
                                })
                              });
                        },
                        onHeavyOperationProcessing: (show) {
                          showProgressBar = show;
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'Permissions not granted',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'License is No more active',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

            // result content on the top of the scanner as a stream builder, to optimize rebuilding of the widget on each success
            StreamBuilder<BarcodeScanningResult>(
                stream: resultStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }

                  Widget pageView;
                  if (snapshot.data?.barcodeImageURI != null) {
                    if (shouldInitWithEncryption) {
                      pageView = EncryptedPageWidget(
                          (snapshot.data?.barcodeImageURI)!);
                    } else {
                      pageView = PageWidget((snapshot.data?.barcodeImageURI)!);
                    }
                  } else {
                    pageView = Container();
                  }

                  return Stack(
                    children: [
                      ListView.builder(
                          itemCount: snapshot.data?.barcodeItems.length ?? 0,
                          itemBuilder: (context, index) {
                            var barcode =
                                snapshot.data?.barcodeItems[index].text ?? '';
                            return Container(
                                color: Colors.white60, child: Text(barcode));
                          }),
                      (snapshot.data?.barcodeImageURI != null)
                          ? Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: 100,
                                height: 200,
                                child: pageView,
                              ),
                            )
                          : Container(),
                    ],
                  );
                }),
            showProgressBar
                ? const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
