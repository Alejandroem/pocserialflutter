import 'dart:developer';
import 'dart:typed_data';

import '../domain/connection.dart';
import 'package:libserialport/libserialport.dart';

class SerialConnection extends Connection {
  String? comPort;
  SerialPort? port;
  bool isConnected = false;

  @override
  Future<bool> connect(String address) async {
    try {
      comPort = address;
      port = SerialPort(address);

      if (port!.openReadWrite()) {
        log('Connected to $address');
        isConnected = true;
        return true;
      }
    } catch (e) {
      log(e.toString());
      disconnect();
    }
    isConnected = false;
    return false;
  }

  @override
  Future<bool> disconnect() async {
    try {
      //Flush all data first
      port!.flush();
      port!.close();
      isConnected = false;
      return true;
    } catch (e) {
      log(e.toString());
    }
    isConnected = false;
    return false;
  }

  @override
  Future<bool> status() async {
    try {
      if (port!.isOpen) {
        log('Connected to $comPort');
        isConnected = true;
        return true;
      }
    } catch (e) {
      log(e.toString());
      disconnect();
    }
    isConnected = false;
    return false;
  }

  @override
  Future<bool> write(List<int> bytes) async {
    try {
      port!.flush();
      port!.write(Uint8List.fromList(bytes), timeout: 500);
      port!.drain();
      return true;
    } catch (e) {
      log(e.toString());
      disconnect();
    }
    return false;
  }

  @override
  Future<List<int>> read() async {
    try {
      final List<int> bytes = port!.read(1024, timeout: 500);
      return bytes;
    } catch (e) {
      log(e.toString());
      disconnect();
    }
    return [];
  }
}
