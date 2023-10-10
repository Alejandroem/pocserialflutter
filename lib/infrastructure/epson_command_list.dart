import '../domain/command_list.dart';

class EpsonCommandList extends CommandList {
  @override
  List<int> get cutPaper => [0x1D, 0x56, 0x00];

  @override
  List<int> get initializePrinter => [0x1B, 0x40];

  @override
  List<int> get lineFeed => [0x0A];

  @override
  List<int> get printAndCarriageReturn => [0x0D, 0x0A];

  @override
  List<int> get print => [0x1B, 0x4A, 0x00];

  @override
  List<int> printAndFeedLines(int lines) => [0x1B, 0x64, lines];

  @override
  List<int> get printAndFeedOneLine => [0x1B, 0x64, 0x01];

  @override
  //upc barcode 12345679 for test
  List<int> printBarCode(List<int> barcode) =>
      [0x1D, 0x6B, 0x02, 0x0A, 0x0A, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37];

  @override
  List<int> print2DBarCode(List<int> barcode) =>
      [0x1D, 0x68, 0x50, 0x1D, 0x77, 0x02, 0x1D, 0x6B, 0x04, ...barcode, 0x00];

  @override
  List<int> get readPrinterStatus => [0x10, 0x04, 0x01];

  @override
  List<int> get selectCaracterPrintMode => [0x1B, 0x21, 0x00];

  @override
  List<int> get kickDrawer => [0x1B, 0x70, 0x00, 0x50, 0x50];
}
