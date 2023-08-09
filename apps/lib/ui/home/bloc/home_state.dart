part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default("") String projectUrl,
    @Default("") String inputText,
    @Default([]) List<DimenData> dataOutput,
    @Default("") String dimenAdd,
    @Default(1.1) double ratioAdd,
  }) = _HomeState;
}
