import 'package:freezed_annotation/freezed_annotation.dart';

part 'dimen_data.freezed.dart';

@freezed
class DimenData with _$DimenData {
  const DimenData._();

  static int baseRatio = 390;

  const factory DimenData({
    required int position,
    required int dimen,
    @Default("") String dataRawText,
  }) = _DimenData;

  double getRatio() {
    final result = (dimen / baseRatio).toStringAsFixed(2);
    double roundedNum = double.parse(result);
    return roundedNum;
  }


  static final List<DimenData> _defaultList = [
    const DimenData(position: 0, dimen: 320),
    const DimenData(position: 1, dimen: 360),
    const DimenData(position: 2, dimen: 411),
    const DimenData(position: 3, dimen: 460),
    const DimenData(position: 4, dimen: 480),
    const DimenData(position: 5, dimen: 600),
    const DimenData(position: 6, dimen: 720),
    const DimenData(position: 7, dimen: 390),
  ];

  static List<DimenData> get defaultList => _defaultList;
}