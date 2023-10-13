import 'dart:developer';

import 'package:flutter/material.dart';

import 'domain/printer.dart';
import 'infrastructure/epson_network_printer.dart';
import 'infrastructure/epson_serial_printer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //String ipAddress = '192.168.100.1';
  String ipAddress = "192.168.100.74";
  String comPort = 'COM3';
  List<String> logs = [];

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
          title: const Text('ESC/POS Printing Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter IP Address',
                ),
                onChanged: (value) {
                  setState(() {
                    ipAddress = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
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
                  networkPrinter!.println(
                      'Hellosssssssssssssssssssssssssssssssssssssssssssssssswwwwwwwwwwwwwwwsssssssss World!');
                  networkPrinter!.feed(2);
                  networkPrinter!.cut();
                  networkPrinter!.kickDrawer(2);
                  networkPrinter!.connection.disconnect();
                },
                child: const Text('Print via IP'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  serialPrinter!.connection.connect(comPort);
                  bool open = await serialPrinter!.isDrawerOpen();
                  log(open.toString());
                  do {
                    await Future.delayed(const Duration(seconds: 1));
                    log("Drawer is open close it");
                  } while (await serialPrinter!.isDrawerOpen());
                  log("Drawer is closed");

                  serialPrinter!.connection.disconnect();
                },
                child: const Text('Drawer Status'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  serialPrinter!.connection.connect(comPort);
                  serialPrinter!.println(
                      'Hello Worldsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss!1');
                  serialPrinter!.kickDrawer(2);
                  serialPrinter!.feed(10);
                  serialPrinter!.cut();
                  serialPrinter!.printBarcode(123123123123123);
                  bool status = await networkPrinter!.isDrawerOpen();
                  log(status.toString());
                  serialPrinter!.connection.disconnect();
                },
                child: const Text('Print via COM'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return Text(logs[index]);
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
