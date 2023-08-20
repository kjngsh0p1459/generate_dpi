import 'dart:async';

import 'package:apps/entity/dimen_data.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resources/resources.dart';

import '../../../helper/file_manager_helper.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  var _projectUrl = S.current.empty;
  var _dataOutput = DimenData.defaultList;

  HomeBloc() : super(const HomeState()) {
    on<UpdateURLEvent>(_handleUpdateURL);

    on<GenerateDimenDataEvent>(_generateDimensionData);

    on<NewDimenConfigEvent>(_addNewDimenConfig);

    on<SetBaseConfigEvent>(_setBaseConfig);
  }

  FutureOr<void> _handleUpdateURL(
      UpdateURLEvent event, Emitter<HomeState> emit) async {
    _projectUrl = event.projectUrl;
    emit(state.copyWith(projectUrl: event.projectUrl));
  }

  FutureOr<void> _generateDimensionData(
      GenerateDimenDataEvent event, Emitter<HomeState> emit) async {
    if (_projectUrl.isEmpty || event.inputText.isEmpty) {
      emit(state.copyWith(isNeedAlert: false));
      emit(state.copyWith(isNeedAlert: true));
    } else {
      for (var i = 0; i < _dataOutput.length; i++) {
        final db = _dataOutput[i];
        final dataRawText = await FileManagerHelper.shared.handleData(
          _projectUrl,
          event.inputText,
          db,
        );
        _dataOutput[i] =  DimenData(
          position: db.position,
          dimen: db.dimen,
          dataRawText: dataRawText,
        );
      };
    }
  }

  FutureOr<void> _addNewDimenConfig(
      NewDimenConfigEvent event, Emitter<HomeState> emit) async {
    final dimen = int.tryParse(event.dimenConfigInputText);
    if (dimen == null) {
      return;
    }
    if (_dataOutput.any((db) => db.dimen == dimen)) {
      return;
    } else {
      final newData = DimenData(
        position: _dataOutput.length,
        dimen: dimen,
        dataRawText: "",
      );
      _dataOutput.add(newData);
      _sortListInputDimen();
      String dimenListConfigText = await getListConfigLabel();
      emit(state.copyWith(dimenListConfigText: dimenListConfigText));
      return;
    }
  }

  FutureOr<void> _setBaseConfig(
      SetBaseConfigEvent event, Emitter<HomeState> emit) async {
    DimenData.baseRatio = event.baseConfigInputText;
  }

  Future<String> getListConfigLabel() async {
    late String labels = "";
    _dataOutput.forEach((element) {
      String label =
          '${labels.isEmpty ? "" : ", "} ${element.dimen.toString()}';
      labels += label;
    });
    return labels;
  }

  FutureOr<void> _sortListInputDimen() async {
    var sortedData = [..._dataOutput]
      ..sort((a, b) => (a.dimen).compareTo(b.dimen));

    for (var index = 0; index < sortedData.length; index++) {
      final item = sortedData[index];
      sortedData[index] = DimenData(position: index, dimen: item.dimen);
    }
    _dataOutput = sortedData;
  }
}
