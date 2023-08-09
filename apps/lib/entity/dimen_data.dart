import 'package:freezed_annotation/freezed_annotation.dart';

part 'dimen_data.freezed.dart';

@freezed
class DimenData with _$DimenData {
  const DimenData._();

  const factory DimenData({
    required int position,
    required int? dimen,
    required double ratio,
    @Default("") String dataRawText,
  }) = _DimenData;

  static List<DimenData> _defaultList = [
    DimenData(position: 0, dimen: 320, ratio: 1),
    DimenData(position: 1, dimen: 360, ratio: 1.125),
    DimenData(position: 2, dimen: 411, ratio: 1.125),
    DimenData(position: 3, dimen: 460, ratio: 1.125),
    DimenData(position: 4, dimen: 480, ratio: 1.437),
    DimenData(position: 5, dimen: 600, ratio: 1.5),
    DimenData(position: 6, dimen: 720, ratio: 1.875),
    DimenData(position: 7, dimen: null, ratio: 1),
  ];

  static List<DimenData> get defaultList => _defaultList;
}