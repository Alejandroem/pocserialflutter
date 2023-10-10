import '../domain/printer.dart';
import 'epson_command_list.dart';
import 'serial_connection.dart';

class EpsonSerialPrinter extends Printer {
  EpsonSerialPrinter() : super(EpsonCommandList(), SerialConnection());
}
