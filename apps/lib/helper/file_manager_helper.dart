import 'dart:convert';
import 'dart:io';
import '../entity/dimen_data.dart';

class FileManagerHelper {
  static final FileManagerHelper _instance = FileManagerHelper();

  static FileManagerHelper shared = _instance;

  Future<String> handleData(String inputProjectUrl, String inputPlainText,
      DimenData dimenData) async {
    final mProjectUrl = dimenData.dimen == DimenData.baseRatio
        ? "values"
        : "values-sw${dimenData.dimen}dp";
    List<String> listInputPlainText = [];
    if (inputPlainText.contains("->")) {
      final fromValue = int.parse(inputPlainText.split('->').first);
      final toValue = int.parse(inputPlainText.split('->').last);
      for (var i = fromValue; i <= toValue; i++) {
        listInputPlainText.add(i.toString());
      }
    } else {
      listInputPlainText = inputPlainText.split(',');
    }
    final folderName = "$inputProjectUrl/$mProjectUrl";
    final fileName = "$folderName/dimens.xml";
    _createFolderIfNotExisted(folderName);
    final outputDimenPlainText =
        await _getDimensionPlainText(listInputPlainText, dimenData);
    final mData = await _readFileData(fileName);
    final fileData = await _sortDimensionTextBeforeWrite(mData, outputDimenPlainText);
    final content = fileData.join('\n');
    _writeDataToFile(dimenData, fileName, utf8.encode(content));
    return content;
  }

  Future<void> _createFolderIfNotExisted(String folderName) async {
    if (!Directory(folderName).existsSync()) {
      final folder = Directory('$folderName');
      folder.createSync(recursive: true);
    }
  }

  Future<List<String>> _getDimensionPlainText(
      List<String> listInputPlainText, DimenData dimenData) async {
    final listDimenParamName = <String>[];
    final uniqueListDimen = <double>{};
    for (final p in listInputPlainText) {
      final item = double.tryParse(p);
      if (item != null && !uniqueListDimen.contains(item)) {
        uniqueListDimen.add(item);
      }
    }
    final sortedListDimen = uniqueListDimen.toList()..sort();

    for (final mDimen in sortedListDimen) {
      final prefix = '<dimen name="dimens_new_${mDimen.toInt()}dp">';
      final result = (mDimen * dimenData.getRatio()).toStringAsFixed(2);
      listDimenParamName.add('$prefix${result}dp</dimen>');
    }
    return listDimenParamName;
  }

  Future<List<String>> _sortDimensionTextBeforeWrite(
      String data, List<String> outputDimenPlainText) async {
    final prefix = '<?xml version="1.0" encoding="utf-8"?>\n<resources>';
    final suffix = '</resources>';
    final oldData = data;
    final newData = <String>[];
    if (oldData.isNotEmpty) {
      final listData = oldData.split('\n');
      for (var i = 2; i < listData.length - 1; i++) {
        if (!outputDimenPlainText.contains(listData[i].trim())) {
          newData.add(listData[i]);
        }
      }
    }
    newData.addAll(outputDimenPlainText.map((p) => '\t$p'));
    newData.insert(0, prefix);
    newData.add(suffix);
    return newData;
  }

  Future<String> _readFileData(String fileName) async {
    final file = File(fileName);
    if (file.existsSync()) {
      try {
        final savedData = file.readAsStringSync();
        print('Read data successfully');
        return savedData;
      } catch (error) {
        print('Error: $error');
      }
    }
    return '';
  }

  Future<void> _writeDataToFile(
      DimenData? dimenData, String fileName, List<int> mData) async {
    final file = File(fileName);
    try {
      await {file.writeAsBytesSync(mData)};
      if (dimenData?.dimen != null) {
        print('File saved: ${dimenData?.dimen}');
      } else {
        print('File saved: original');
      }
    } catch (error) {
      print('Error $error');
    }
  }
}
