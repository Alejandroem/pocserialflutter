import 'dart:developer';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../domain/connection.dart';

class NetworkConnection extends Connection {
  CapabilityProfile? profile;
  NetworkPrinter? printer;
  String? ipAddress;
  bool isConnected = false;

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
      final PosPrintResult res = await printer!.connect(ipAddress!, port: 9100);
      if (res == PosPrintResult.success) {
        log('Print success.');
        isConnected = true;
        return true;
      } else {
        log('Print error: $res');
        isConnected = false;
        return false;
      }
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
      if (printer != null) {
        printer!.disconnect();
        isConnected = false;
      }
      return true;
    } catch (e) {
      log(e.toString());
      isConnected = false;
      return false;
    }
  }

  @override
  Future<bool> status() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> write(List<int> bytes) async {
    try {
      printer!.rawBytes(bytes);
      return true;
    } catch (e) {
      log(e.toString());
      disconnect();
      return false;
    }
  }
}
