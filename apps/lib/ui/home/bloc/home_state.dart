part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default("") String projectUrl,
    @Default("1,2,3,4,5") String inputText,
    @Default("320, 360, 411, 460, 480, 600, 720") String dimenListConfigText,
    @Default(false) bool isNeedAlert,
  }) = _HomeState;
}
