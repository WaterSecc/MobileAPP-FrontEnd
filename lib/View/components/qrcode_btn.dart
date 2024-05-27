import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerButton extends StatefulWidget {
  @override
  _QRCodeScannerButtonState createState() => _QRCodeScannerButtonState();
}

class _QRCodeScannerButtonState extends State<QRCodeScannerButton> {
  QRViewController? _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    _controller!.scannedDataStream.listen((scanData) {
      print('Scanned QR code: ${scanData.code}');
      // Handle the scanned QR code here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _scanQRCode(context);
          },
          child: Text('Scan QR Code'),
        ),
        SizedBox(height: 16),
        Expanded(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
      ],
    );
  }

  Future<void> _scanQRCode(BuildContext context) async {
    if (_controller != null) {
      try {
        await _controller!.toggleFlash();
      } catch (e) {
        print('Failed to toggle flash: $e');
      }
    }
  }
}
