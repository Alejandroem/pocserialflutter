import 'package:flutter/material.dart';

import 'domain/printer.dart';
import 'infrastructure/epson_network_printer.dart';
import 'infrastructure/epson_serial_printer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String ipAddress = '192.168.100.1';
  String comPort = 'COM3';
  List<String> log = [];

  Printer? serialPrinter;
  Printer? networkPrinter;

  @override
  void initState() {
    super.initState();

    serialPrinter = EpsonSerialPrinter();
    networkPrinter = EpsonNetworkPrinter();
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
                onPressed: () {
                  networkPrinter!.connection.connect(ipAddress);
                  networkPrinter!.println('Hello World!');
                  networkPrinter!.feed(2);
                  networkPrinter!.cut();
                  networkPrinter!.kickDrawer(2);
                  networkPrinter!.printBarcode(123456789);
                  networkPrinter!.connection.disconnect();
                },
                child: Text('Print via IP'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  serialPrinter!.connection.connect(comPort);
                  serialPrinter!.println(
                      'Hello Worldsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss!1');
                  //serialPrinter!.kickDrawer(2);
                  serialPrinter!.feed(10);
                  serialPrinter!.cut();
                  serialPrinter!.printBarcode(123123123123123);
                  serialPrinter!.connection.disconnect();
                },
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
