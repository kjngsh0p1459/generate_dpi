import 'dart:async';

import 'package:apps/entity/dimen_data.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helper/file_manager_helper.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>(
      _pushHomeEvent,
    );

    on<HomeEvent>((event, emit) {
    });
  }

  FutureOr<void> _pushHomeEvent(HomeEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(

    ));

  }

  final _projectUrl = BehaviorSubject<String>.seeded("");
  final _inputText = BehaviorSubject<String>.seeded("");
  final _dataOutput = BehaviorSubject<List<DimenData>>.seeded([]);
  final _dimenAdd = BehaviorSubject<String>.seeded("360");
  final _ratioAdd = BehaviorSubject<double>.seeded(1.1);

  // Streams
  Stream<String> get projectUrlStream => _projectUrl.stream;
  Stream<String> get inputTextStream => _inputText.stream;
  Stream<List<DimenData>> get dataOutputStream => _dataOutput.stream;
  Stream<String> get dimenAddStream => _dimenAdd.stream;
  Stream<double> get ratioAddStream => _ratioAdd.stream;

  // Sink
  Function(String) get updateProjectUrl => _projectUrl.sink.add;
  Function(String) get updateInputText => _inputText.sink.add;
  Function(List<DimenData>) get updateDataOutput => _dataOutput.sink.add;
  Function(String) get updateDimenAdd => _dimenAdd.sink.add;
  Function(double) get updateRatioAdd => _ratioAdd.sink.add;


  void _initData() {
    final initialData = DimenData.defaultList;
    _dataOutput.add(initialData);
    _sortListInputDimen();
  }

  void pushDimensionData() {
    final mDataOutput = <DimenData>[];
    _dataOutput.value.forEach((db) {
      final dataRawText = FileManagerHelper.handleData(
        _projectUrl.value,
        _inputText.value,
        db,
      );
      mDataOutput.add(DimenData(
        position: db.position,
        dimen: db.dimen,
        ratio: db.ratio,
        dataRawText: dataRawText,
      ));
    });
    _dataOutput.add(mDataOutput);
  }

  bool addDimensionData() {
    final dimen = int.tryParse(_dimenAdd.value);
    if (dimen == null) return false;
    if (_dataOutput.value.any((db) => db.dimen == dimen)) {
      return false;
    } else {
      final newData = DimenData(
        position: _dataOutput.value.length,
        dimen: dimen,
        ratio: _ratioAdd.value,
        dataRawText: "",
      );
      _dataOutput.add([..._dataOutput.value, newData]);
      _sortListInputDimen();
      return true;
    }
  }

  void _sortListInputDimen() {
    final sortedData = [..._dataOutput.value]
      ..sort((a, b) => (a.dimen ?? 0).compareTo(b.dimen ?? 0));

    // for (var index = 0; index < sortedData.length; index++) {
    //   sortedData[index].position = index;
    // }

    _dataOutput.add(sortedData);
  }

  void dispose() {
    _projectUrl.close();
    _inputText.close();
    _dataOutput.close();
    _dimenAdd.close();
    _ratioAdd.close();
  }
}
