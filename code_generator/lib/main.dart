import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: pageTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum AvailableBarcodeEncoder { code39, code93, qrCode }

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _selectedQrCode = false;
  bool _selectedCode93 = false;
  bool _selectedCode39 = false;
  var textToDisplayInputBox = "Enter a Value (integer or string) to Encode";

  int index = 0;
  Barcode barcodeValue = Barcode.qrCode(
    errorCorrectLevel: BarcodeQRCorrectionLevel.high,
  );

  @override
  Widget build(BuildContext context) {
    generateCode() {
      setState(() {});
    }

    changeEncoder(value) {
      setState(() {
        if (value == AvailableBarcodeEncoder.code39) {
          index = AvailableBarcodeEncoder.code39.index;
          barcodeValue = Barcode.code39();
          _selectedCode39 = true;
          textToDisplayInputBox = intOnlyPlaceHolder;
        } else if (value == AvailableBarcodeEncoder.code93) {
          index = AvailableBarcodeEncoder.code93.index;
          barcodeValue = Barcode.code93();
          _selectedCode93 = true;
          textToDisplayInputBox = intOnlyPlaceHolder;
        } else if (value == AvailableBarcodeEncoder.qrCode) {
          index = AvailableBarcodeEncoder.qrCode.index;
          barcodeValue = Barcode.qrCode();
          _selectedQrCode = true;
          textToDisplayInputBox = textOnlyPlaceHolder;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(codeTypeDescription, textAlign: TextAlign.left),
            RadioMenuButton(
              value: AvailableBarcodeEncoder.qrCode,
              groupValue: AvailableBarcodeEncoder,
              onChanged: changeEncoder,
              child: Text(
                AvailableBarcodeEncoder.qrCode.name,
                style: TextStyle(
                  color: (AvailableBarcodeEncoder.qrCode.index == index)
                      ? Colors.green
                      : Colors.black,
                ),
              ),
            ),
            RadioMenuButton(
              value: AvailableBarcodeEncoder.code39,
              groupValue: AvailableBarcodeEncoder,
              onChanged: changeEncoder,
              child: Text(
                AvailableBarcodeEncoder.code39.name,
                style: TextStyle(
                  color: (AvailableBarcodeEncoder.code39.index == index)
                      ? Colors.green
                      : Colors.black,
                ),
              ),
            ),
            RadioMenuButton(
              value: AvailableBarcodeEncoder.code93,
              groupValue: AvailableBarcodeEncoder,
              onChanged: changeEncoder,
              child: Text(
                AvailableBarcodeEncoder.code93.name,
                style: TextStyle(
                  color: (AvailableBarcodeEncoder.code93.index == index)
                      ? Colors.green
                      : Colors.black,
                ),
              ),
            ),
            TextField(
              enabled: true,
              controller: _controller,
              decoration: barcodeValue != Barcode.qrCode()
                  ? InputDecoration(
                      labelText: textToDisplayInputBox,
                    )
                  : InputDecoration(
                      labelText: textToDisplayInputBox,
                    ),
            ),
            ElevatedButton(
                onPressed: () => generateCode(),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(generateButtonText),
                    IconButton(
                      icon: const Icon(
                        Icons.create_new_folder,
                        semanticLabel: 'Generate',
                      ),
                      onPressed: () => generateCode(),
                    ),
                  ],
                )),
            BarcodeWidget(
              // barcode: barcodeValue.isNull ? Barcode.qrCode() : barcodeValue!,
              barcode: barcodeValue,
              data: _controller.value.text,
              errorBuilder: (context, error) => _controller.value.text.isEmpty
                  ? const Center(child: Text(errorText))
                  : Center(child: Text(error)),
              width: 200,
              height: 200,
            )
          ],
        ),
      ),
      bottomSheet: const Text(poweredBy),
    );
  }
}
