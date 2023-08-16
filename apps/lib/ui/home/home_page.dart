import 'dart:io';
import 'package:apps/ui/home/bloc/home_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late HomeBloc bloc;
  late String inputDimenData;

  @override
  Widget build(BuildContext context) {
    bloc = HomeBloc();
    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Generate DPI'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: _ColumnBuilder(
            onWindowClosed: () {
              windowShouldClose(context);
            },
            onProjectSelected: () {
              selectDocumentFolder();
            },
            onGenerateButtonClicked: () {
              bloc.add(GenerateDimenDataEvent(inputText: inputDimenData));
            },
            onNewDimenConfigClicked: () {
              bloc.add(GenerateDimenDataEvent(inputText: inputDimenData));
            },
          ),
        ),
      ),
    );
  }

  Future<void> selectDocumentFolder() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        bloc.add(UpdateURLEvent(projectUrl: result));
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  void windowShouldClose(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quit"),
          content: Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                exit(0);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}

class _ColumnBuilder extends StatelessWidget {
  const _ColumnBuilder({
    required this.onProjectSelected,
    required this.onWindowClosed,
    required this.onGenerateButtonClicked,
    required this.onNewDimenConfigClicked,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onProjectSelected;
  final VoidCallback? onWindowClosed;
  final VoidCallback? onGenerateButtonClicked;
  final VoidCallback? onNewDimenConfigClicked;

  @override
  Widget build(BuildContext context) {
    String dimenInputText = "1,2,3,4,5";

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.white,
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) =>
                previous.projectUrl != current.projectUrl,
                builder: (_, state) => Text(state.projectUrl),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onProjectSelected,
              child: Text("Select project"),
            ),
            SizedBox(height: 10),
            TextField(
                decoration: InputDecoration(hintText: dimenInputText),
                onChanged: (textChanged) {
                  dimenInputText = textChanged;
                }
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onGenerateButtonClicked,
              child: Text("Generate Dimension"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Dimension"),
                SizedBox(width: 10),
                Container(
                  width: 35,
                  child: TextField(
                    decoration: InputDecoration(hintText: "320"),
                  ),
                ),
                SizedBox(width: 10),
                Text("Ratio"),
                SizedBox(width: 10),
                Container(
                  width: 35,
                  child: TextField(
                    decoration: InputDecoration(hintText: "1.0"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onNewDimenConfigClicked,
                  child: Text("Add more"),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onWindowClosed,
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

