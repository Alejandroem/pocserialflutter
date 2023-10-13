import 'dart:developer';
import 'dart:io';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../domain/connection.dart';

class NetworkConnection extends Connection {
  CapabilityProfile? profile;
  NetworkPrinter? printer;
  String? ipAddress;
  bool isConnected = false;
  Socket? socket;

  Future<void> initialize() async {
    profile = await CapabilityProfile.load();
    printer = NetworkPrinter(
      PaperSize.mm80,
      profile!,
    );
  }

  @override
  Future<bool> connect(String address) async {
    try {
      ipAddress = address;
      socket = await Socket.connect(address, 9100,
          timeout: const Duration(seconds: 5));
      return true;
      /* await initialize();
      final PosPrintResult res =
          await printer!.connect("192.168.100.74", port: 1234);
      if (res == PosPrintResult.success) {
        log('connection success.');
        isConnected = true;
        return true;
      } else {
        log('Print error: ${res.msg}');
        isConnected = false;
        return false;
      } */
    } catch (e) {
      log(e.toString());
      isConnected = false;
      disconnect();
      return false;
    }
  }

  @override
  Future<bool> disconnect() async {
    try {
      if (socket != null) {
        socket!.destroy();
        isConnected = false;
      }
      return true;
    } catch (e) {
      log(e.toString());
      isConnected = false;
      return false;
    }
    /* try {
      if (printer != null) {
        printer!.disconnect();
        isConnected = false;
      }
      return true;
    } catch (e) {
      log(e.toString());
      isConnected = false;
      return false;
    } */
  }

  @override
  Future<bool> status() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> write(List<int> bytes) async {
    try {
      socket!.add(bytes);
      await socket!.flush();
      return true;
    } catch (e) {
      log("Error while sending print command: $e");
      disconnect();
    }
    return false;
    /*  try {
      printer!.rawBytes(bytes);
      return true;
    } catch (e) {
      log(e.toString());
      disconnect();
      return false;
    } */
  }

  @override
  Future<List<int>> read() async {
    try {
      return [];
    } catch (e) {
      log(e.toString());
      disconnect();
      return [];
    }
  }
}
