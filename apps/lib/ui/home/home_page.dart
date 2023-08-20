import 'dart:io';
import 'package:apps/entity/dimen_data.dart';
import 'package:apps/shared_view/app_label.dart';
import 'package:apps/shared_view/app_text_field.dart';
import 'package:apps/ui/home/bloc/home_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late final HomeBloc _bloc = HomeBloc();
  final _dimenInputTextController = TextEditingController();
  final _baseConfigTextController = TextEditingController();
  final _dimenConfigInputTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.app_name),
        ),
        body: BlocPageListeners(
            child: Container(
          padding: EdgeInsets.all(Dimens.d20.responsive()),
          child: _ColumnBuilder(context),
        )),
      ),
    );
  }

  Widget BlocPageListeners({required Widget child}) {
    return
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => !previous.isNeedAlert && current.isNeedAlert,
          listener: (context, state) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return getWarningDialog(S.current.generateFailDialog, () {
                  Navigator.of(context).pop();
                }, () {
                  Navigator.of(context).pop();
                });
              },
            );
            },
            child: child
        );
  }

  Future<void> _selectDocumentFolder() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        _bloc.add(UpdateURLEvent(projectUrl: result));
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  Future<void> _windowShouldClose(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return getWarningDialog(S.current.confirm, () {
          exit(0);
        }, () {
          Navigator.of(context).pop();
        });
      },
    );
  }

  AlertDialog getWarningDialog(String content, Function ok, Function cancel) {
    return AlertDialog(
      title: Text(S.current.quit),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            ok.call();
          },
          child: Text(S.current.ok),
        ),
        TextButton(
          onPressed: () {
            cancel.call();
          },
          child: Text(S.current.cancel),
        ),
      ],
    );
  }

  Widget _ColumnBuilder(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
              previous.projectUrl != current.projectUrl,
              builder: (_, state) => AppLabel(title: S.current.generateURLTitle, content: state.projectUrl),
            ),
            SizedBox(height: Dimens.d10.responsive()),
            ElevatedButton(
              onPressed: () { _selectDocumentFolder(); },
              child: Text(S.current.selectFolder),
            ),
            SizedBox(height: Dimens.d10.responsive()),
            AppTextField(
              hintText: S.current.dimenInputHintText,
              controller: _dimenInputTextController, title: S.current.dimenTitle,
            ),
            SizedBox(height: Dimens.d10.responsive()),
            ElevatedButton(
              onPressed: () {
                _bloc.add(GenerateDimenDataEvent(inputText: _dimenInputTextController.text));
                },
              child: Text(S.current.generateDimen),
            ),
            SizedBox(height: Dimens.d10.responsive()),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
              previous.dimenListConfigText != current.dimenListConfigText,
              builder: (_, state) => Text(state.dimenListConfigText),
            ),
            SizedBox(height: Dimens.d10.responsive()),
            Row(
              children: [
                Text(S.current.baseConfigTitle),
                SizedBox(width: Dimens.d10.responsive()),
                SizedBox(
                  width: Dimens.d35.responsive(),
                  child: AppTextField(
                      hintText: DimenData.baseRatio.toString(),
                      controller: _baseConfigTextController
                  ),
                ),
                SizedBox(width: Dimens.d10.responsive()),
                ElevatedButton(
                  onPressed: () {
                    _bloc.add(SetBaseConfigEvent(
                        baseConfigInputText: int.parse(_baseConfigTextController.text)));
                  },
                  child: Text(S.current.setConfig),
                ),
              ],
            ),
            Row(
              children: [
                Text(S.current.dimen),
                SizedBox(width: Dimens.d10.responsive()),
                SizedBox(
                  width: Dimens.d35.responsive(),
                  child: AppTextField(
                      hintText: S.current.empty,
                      controller: _dimenConfigInputTextController
                  ),
                ),
                SizedBox(width: Dimens.d10.responsive()),
                ElevatedButton(
                  onPressed: () {
                    _bloc.add(NewDimenConfigEvent(
                        dimenConfigInputText: _dimenConfigInputTextController.text));
                    },
                  child: Text(S.current.addConfig),
                ),
              ],
            ),
            SizedBox(height: Dimens.d10.responsive()),
            ElevatedButton(
              onPressed:  ()
        {
          _windowShouldClose(context);
        },
                child: Text(S.current.close),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _dimenInputTextController.dispose();
    _dimenConfigInputTextController.dispose();
    super.dispose();
  }
}

