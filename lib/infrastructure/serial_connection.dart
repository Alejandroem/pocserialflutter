import 'dart:developer';
import 'dart:typed_data';

import '../domain/connection.dart';
import 'package:libserialport/libserialport.dart';

class SerialConnection extends Connection {
  String? comPort;
  SerialPort? port;
  bool isConnected = false;

  @override
  Future<bool> connect(String comPort) async {
    try {
      this.comPort = comPort;
      port = SerialPort(comPort);

      if (port!.openReadWrite()) {
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
}
