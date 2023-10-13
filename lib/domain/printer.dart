import 'dart:typed_data';

import 'command_list.dart';
import 'connection.dart';

abstract class Printer {
  final CommandList commands;
  final Connection connection;

  Printer(this.commands, this.connection);

  Future<bool> print(String text) async {
    try {
      //initialize
      final List<int> initializeCommand = commands.initializePrinter;
      connection.write(initializeCommand);
      final List<int> bytes = Uint8List.fromList(text.codeUnits);
      final List<int> command = commands.print;
      connection.write(bytes + command);
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> println(String text) async {
    try {
      final List<int> bytes = Uint8List.fromList(text.codeUnits);
      final List<int> command = commands.printAndFeedOneLine;
      connection.write(bytes + command);

      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> feed(int lines) async {
    try {
      final List<int> command = commands.printAndFeedLines(lines);
      connection.write(command);

      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> cut() async {
    try {
      final List<int> command = commands.cutPaper;
      connection.write(command);

      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> kickDrawer(int pin) async {
    try {
      final List<int> command = commands.kickDrawer;
      connection.write(command);

      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> printBarcode(int barcode) async {
    try {
      final List<int> initializeCommand = commands.initializePrinter;
      final List<int> barcodeCommand =
          commands.print2DBarCode(barcode.toString().codeUnits);
      final List<int> bytes = Uint8List.fromList(barcode.toString().codeUnits);
      final List<int> command = commands.print;
      connection.write(initializeCommand + barcodeCommand + bytes + command);
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> isDrawerOpen() async {
    try {
      final List<int> command = commands.drawerStatus;
      connection.write(command);
      final List<int> response = await connection.read();
      if (response.first == 22) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
