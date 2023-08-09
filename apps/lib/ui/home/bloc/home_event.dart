part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent({
    required String projectUrl,
    required String inputText,
    required List<DimenData> dataOutput,
    @Default("") String dimenAdd,
    @Default(1.1) double ratioAdd,
  }) = _HomeEvent;
}
