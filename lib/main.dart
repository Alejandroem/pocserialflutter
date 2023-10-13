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
  String ipAddress = "192.168.100.74";
  String comPort = 'COM3';
  List<String> logs = [];
  String printText = '';
  int feedLines = 1;

  Printer? serialPrinter;
  Printer? networkPrinter;

  bool isNetworkConnection = true;

  @override
  void initState() {
    super.initState();
    serialPrinter = EpsonSerialPrinter();
    networkPrinter = EpsonNetworkPrinter();
  }

  void logAction(String message) {
    setState(() {
      logs.add(message);
    });
    log(message);
  }

  Future<void> executePrinterCommand(Function action) async {
    Printer? activePrinter =
        isNetworkConnection ? networkPrinter : serialPrinter;
    await activePrinter!.connection
        .connect(isNetworkConnection ? ipAddress : comPort);
    await action();
    await activePrinter.connection.disconnect();
  }

  Future<void> openDrawerAndWait(Printer? printer) async {
    await executePrinterCommand(() async {
      await printer!.kickDrawer(2);
      int counter = 0;
      do {
        await Future.delayed(const Duration(seconds: 1));
        counter++;
        if (counter > 10) {
          logAction('Drawer did not open after 10 seconds via');
          break;
        }
        logAction('Waiting for drawer to close');
      } while (await printer.isDrawerOpen());
      logAction('Closed drawer via $serialPrinter');
    });
  }

  @override
  Widget build(BuildContext context) {
    String activeConnectionType = isNetworkConnection ? "Network" : "Serial";

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
          child: Stack(
            children: [
              Column(
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        printText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Text to print',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        feedLines = int.tryParse(value) ?? 1;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Number of lines to feed',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Connection Type'),
                    value: isNetworkConnection,
                    onChanged: (bool value) {
                      setState(() {
                        isNetworkConnection = value;
                      });
                    },
                    secondary: const Icon(Icons.swap_horiz),
                    subtitle: Text('Currently using: $activeConnectionType'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await executePrinterCommand(() async {
                        if (isNetworkConnection) {
                          await networkPrinter!.print(printText);
                        } else {
                          await serialPrinter!.print(printText);
                        }
                      });
                      logAction('Printed text via $activeConnectionType');
                    },
                    child: Text('Print Text via $activeConnectionType'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await executePrinterCommand(() async {
                        if (isNetworkConnection) {
                          await networkPrinter!.feed(feedLines);
                        } else {
                          await serialPrinter!.feed(feedLines);
                        }
                      });
                      logAction('Fed lines via $activeConnectionType');
                    },
                    child: Text('Feed Lines via $activeConnectionType'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await executePrinterCommand(() async {
                        if (isNetworkConnection) {
                          await networkPrinter!.cut();
                        } else {
                          await serialPrinter!.cut();
                        }
                      });
                      logAction('Cut paper via $activeConnectionType');
                    },
                    child: Text('Cut Paper via $activeConnectionType'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await executePrinterCommand(() async {
                        if (isNetworkConnection) {
                          await networkPrinter!.kickDrawer(2);
                        } else {
                          await serialPrinter!.kickDrawer(2);
                        }
                      });
                    },
                    child: const Text('Kick Drawer'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await executePrinterCommand(() async {
                        if (isNetworkConnection) {
                          bool open = await networkPrinter!.isDrawerOpen();
                          logAction(
                              'Drawer status: ' + (open ? 'Open' : 'Closed'));
                        } else {
                          bool open = await serialPrinter!.isDrawerOpen();
                          logAction(
                              'Drawer status: ' + (open ? 'Open' : 'Closed'));
                        }
                      });
                    },
                    child: const Text('Check Drawer Status'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (isNetworkConnection) {
                        await openDrawerAndWait(networkPrinter);
                      } else {
                        await openDrawerAndWait(serialPrinter);
                      }
                    },
                    child:
                        Text('Open Drawer and Wait via $activeConnectionType'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      return Text(logs[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
