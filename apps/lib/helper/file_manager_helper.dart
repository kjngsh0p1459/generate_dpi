import 'dart:convert';
import 'dart:io';
import '../entity/dimen_data.dart';

class FileManagerHelper {
  static String handleData(
      String inputProjectUrl, String inputPlainText, DimenData dimenData) {
    final mProjectUrl =
    dimenData.dimen == null ? "values" : "values-sw${dimenData.dimen}dp";
    final listInputPlainText = inputPlainText.split(',');
    final folderName = "$inputProjectUrl/app/src/main/res/$mProjectUrl";
    final fileName = "$folderName/dimens.xml";
    createFolderIfNotExisted(folderName);
    final outputDimenPlainText =
    getDimensionPlainText(listInputPlainText, dimenData);
    final mData = readFileData(fileName);
    final fileData = sortDimensionTextBeforeWrite(mData, outputDimenPlainText);
    final content = fileData.join('\n');
    writeDataToFile(dimenData, fileName, utf8.encode(content));
    return content;
  }

  static void createFolderIfNotExisted(String folderName) {
    if (!Directory(folderName).existsSync()) {
      final documentDirectory = Directory.systemTemp;
      final folder = Directory('$folderName');
      folder.createSync(recursive: true);
    }
  }

  static List<String> getDimensionPlainText(
      List<String> listInputPlainText, DimenData dimenData) {
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
      listDimenParamName.add(
          '$prefix${roundf(mDimen * (dimenData.ratio))}dp</dimen>');
    }
    return listDimenParamName;
  }

  static List<String> sortDimensionTextBeforeWrite(
      String data, List<String> outputDimenPlainText) {
    final firstLine = '<?xml version="1.0" encoding="utf-8"?>';
    final secondLine = '<resources>';
    final oldData = data;
    final newData = <String>[];
    oldData.split('\n').forEach((p) {
      if (!outputDimenPlainText.contains(p.trim())) {
        newData.add(p);
      }
    });
    newData.removeLast();
    newData.addAll(outputDimenPlainText.map((p) => '\t$p'));
    if (newData.first != firstLine) {
      newData.insert(0, firstLine);
      newData.insert(1, secondLine);
    }
    newData.add('</resources>');
    return newData;
  }

  static String readFileData(String fileName) {
    final file = File(fileName);
    if (file.existsSync()) {
      try {
        final savedData = file.readAsStringSync();
        print('Read data successfully');
        return savedData;
      } catch (error) {
        print('Error $error');
      }
    }
    return '';
  }

  static void writeDataToFile(
      DimenData? dimenData, String fileName, List<int> mData) {
    final file = File(fileName);
    try {
      file.writeAsBytesSync(mData);
      if (dimenData?.dimen != null) {
        print('File saved: ${dimenData?.dimen}');
      } else {
        print('File saved: original');
      }
    } catch (error) {
      print('Error $error');
    }
  }

  static String roundf(double mValue, [double divide = 100.0]) {
    final valueAfterCal = (mValue * 100).round() / divide;
    return valueAfterCal.toString();
  }
}

