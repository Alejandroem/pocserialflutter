import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:libserialport/libserialport.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String ipAddress = '192.168.100.1';
  String comPort = 'COM3';
  List<String> log = [];

  Future<void> printViaNetwork() async {
    try {
      final profile = await CapabilityProfile.load();
      setState(() {
        log.add('Printing to IP: $ipAddress');
      });
      final printer = NetworkPrinter(
        PaperSize.mm80,
        profile,
      );

      setState(() {
        log.add('Printing to IP: $ipAddress');
      });

      final PosPrintResult res = await printer.connect(ipAddress, port: 9100);
      if (res == PosPrintResult.success) {
        printer.text('Hello World! from: Flutter dev');
        setState(() {
          log.add('Hello World! from: Flutter dev');
        });

        await Future.delayed(Duration(milliseconds: 500));
        printer.feed(2);
        setState(() {
          log.add('feed 2');
        });
        await Future.delayed(Duration(milliseconds: 500));
        printer.cut();
        setState(() {
          log.add('cut');
        });
        await Future.delayed(Duration(milliseconds: 500));
        printer.disconnect();
        setState(() {
          log.add('disconnect');
        });
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          log.add('Print success.');
        });

        await Future.delayed(Duration(milliseconds: 500));
      } else {
        print('Could not print. Connect and try again.');
        setState(() {
          log.add('Could not print. Connect and try again.');
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        log.add(e.toString());
      });
    }
  }

  Future<void> printViaSerial() async {
    final port = SerialPort(comPort);

    if (!port.openReadWrite()) {
      print('Failed to open port');
      return;
    }

    Uint8List initPrinter = Uint8List.fromList([0x1B, 0x40]); // ESC @
    Uint8List printText =
        Uint8List.fromList('Success test from Flutter dev via COM'.codeUnits);
    Uint8List feedPaper =
        Uint8List.fromList([0x0A, 0x0A, 0x0A, 0x0A, 0x0A]); // 5 line feeds

    Uint8List cutPaper = Uint8List.fromList([0x1D, 0x56, 0x00]); // Full cut

    Uint8List drawer =
        Uint8List.fromList([0x1B, 0x70, 0x00, 0x19, 0xFA]); // Kick drawer

    port.write(initPrinter);
    await Future.delayed(Duration(milliseconds: 500));
    port.write(printText);
    await Future.delayed(Duration(milliseconds: 500));
    port.write(feedPaper);
    await Future.delayed(Duration(milliseconds: 500));
    port.write(cutPaper);
    await Future.delayed(Duration(milliseconds: 500));
    port.write(drawer);
    await Future.delayed(Duration(milliseconds: 500));

    port.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ESC/POS Printing Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter IP Address',
                ),
                onChanged: (value) {
                  setState(() {
                    ipAddress = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter COM Port',
                ),
                onChanged: (value) {
                  setState(() {
                    comPort = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: printViaNetwork,
                child: Text('Print via IP'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: printViaSerial,
                child: Text('Print via COM'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: log.length,
                  itemBuilder: (context, index) {
                    return Text(log[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
