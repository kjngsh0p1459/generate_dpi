part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

@freezed
class UpdateURLEvent extends HomeEvent with _$UpdateURLEvent {
  const factory UpdateURLEvent({@Default("") String projectUrl}) =
      _UpdateURLEvent;
}

@freezed
class GenerateDimenDataEvent extends HomeEvent with _$GenerateDimenDataEvent {
  const factory GenerateDimenDataEvent({@Default("") String inputText}) =
      _GenerateDimenDataEvent;
}

@freezed
class NewDimenConfigEvent extends HomeEvent with _$NewDimenConfigEvent {
  const factory NewDimenConfigEvent(
      {@Default("") String dimenConfigInputText,
      @Default("") String ratioInputText}) = _NewDimenConfigEvent;
}
