part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default("") String projectUrl,
    @Default("1,2,3,4,5") String inputText,
    @Default("320") String dimenAdd,
    @Default(1.1) double ratioAdd,
  }) = _HomeState;
}
