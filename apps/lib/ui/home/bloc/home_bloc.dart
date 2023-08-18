import 'dart:async';
import 'dart:ffi';

import 'package:apps/entity/dimen_data.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resources/resources.dart';

import '../../../helper/file_manager_helper.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  var _projectUrl = "";
  var _dataOutput = DimenData.defaultList;

  HomeBloc() : super(const HomeState()) {
    on<UpdateURLEvent>(_handleUpdateURL);

    on<GenerateDimenDataEvent>(_generateDimensionData);

    on<NewDimenConfigEvent>(_addNewDimenConfig);
  }

  FutureOr<void> _handleUpdateURL(
      UpdateURLEvent event, Emitter<HomeState> emit) async {
    _projectUrl = event.projectUrl;
    emit(state.copyWith(projectUrl: event.projectUrl));
  }

  FutureOr<void> _generateDimensionData(
      GenerateDimenDataEvent event, Emitter<HomeState> emit) async {
    final mDataOutput = <DimenData>[];
    _dataOutput.forEach((db) {
      final dataRawText = FileManagerHelper.shared.handleData(
        _projectUrl,
        event.inputText,
        db,
      );
      mDataOutput.add(DimenData(
        position: db.position,
        dimen: db.dimen,
        ratio: db.ratio,
        dataRawText: dataRawText,
      ));
    });
    _dataOutput.addAll(mDataOutput);
  }

  FutureOr<void> _addNewDimenConfig(
      NewDimenConfigEvent event, Emitter<HomeState> emit) async {
    final dimen = int.tryParse(event.dimenConfigInputText);
    final ratio = double.tryParse(event.ratioInputText) ?? 0.0;
    if (dimen == null) {
      return;
    }
    if (_dataOutput.any((db) => db.dimen == dimen)) {
      return;
    } else {
      final newData = DimenData(
        position: _dataOutput.length,
        dimen: dimen,
        ratio: ratio,
        dataRawText: "",
      );
      _dataOutput.add(newData);
      _sortListInputDimen();
      String dimenListConfigText = await getDefaultListConfigLabel();
      emit(state.copyWith(dimenListConfigText: dimenListConfigText));
      return;
    }
  }

  Future<String> getDefaultListConfigLabel() async {
    late String labels = "";
    _dataOutput.forEach((element) {
      if (element.dimen != null) {
        String label = '${labels.isEmpty ? "" : ", "} ${element.dimen.toString()}';
        labels += label;
      }
    });
    return labels;
  }

  FutureOr<void> _sortListInputDimen() async {
    var sortedData = [..._dataOutput]
      ..sort((a, b) => (a.dimen ?? 0).compareTo(b.dimen ?? 0));

    for (var index = 0; index < sortedData.length; index++) {
      final item = sortedData[index];
      sortedData[index] =
          DimenData(position: index, dimen: item.dimen, ratio: item.ratio);
    }
    _dataOutput = sortedData;
  }
}
