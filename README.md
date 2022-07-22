# Scanbot Barcode Scanner SDK Flutter Example

This example app shows how to integrate the [Scanbot Barcode Scanner SDK Flutter Plugin](https://pub.dev/packages/barcode_scanner) on Android and iOS.

For more details about the Plugin please see this [documentation](https://docs.scanbot.io/barcode-scanner-sdk/flutter/introduction/).


## What is Scanbot Barcode Scanner SDK?

The Scanbot Barcode Scanner SDK brings barcode scanning capabilities to your mobile apps.
It provides functionality for scanning 1D and 2D barcodes, like EAN, UPC, QR code, Data Matrix, PDF 417, etc.
For more details visit our website https://scanbot.io


## How to run this app

Install [Flutter](https://flutter.dev) and all required dev tools.

Fetch this repository and navigate to the project directory.

```
cd scanbot-barcode-scanner-sdk-example-flutter/
```

Fetch and install the dependencies of this example project via Flutter CLI:

```
flutter pub get
```

Connect a mobile device via USB and run the app.

**Android:**

```
flutter run -d <DEVICE_ID>
```

You can get the IDs of all connected devices via `flutter devices`.

**iOS:**

Install Pods dependencies:

```
cd ios/
pod install --repo-update
```

Open the **workspace**(!) `ios/Runner.xcworkspace` in Xcode and adjust the *Signing / Developer Account* settings.
Then build and run the app in Xcode.


## Please note

The Scanbot Barcode Scanner SDK will run without a license for one minute per session!

After the trial period has expired all Barcode SDK functions as well as the UI components (like Barcode Scanner UI) will
stop working. You have to restart the app to get another trial period.

To get a free "no-strings-attached" trial license, please submit the 
[Trial License Form](https://scanbot.io/trial/) on our website.
