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

String projectUrl = "";

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<HomeBloc>(context);

    return BlocProvider(
      create: (BuildContext context) => HomeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your App'),
        ),
        body: Container(
          child: _ColumnBuilder(
            onWindowClosed: () {
              windowShouldClose(context);
            },
            onProjectSelected: () {
              bloc.add(HomeEvent(projectUrl: "", inputText: "", dataOutput: []));
              selectDocumentFolder();
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
        setState(() {
          projectUrl = result;
        });
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
    Key? key,
  }) : super(key: key);

  final VoidCallback? onProjectSelected;
  final VoidCallback? onWindowClosed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            _TopContainer(),
            ElevatedButton(
              onPressed: onProjectSelected,
              child: Text("Select project"),
            ),
            TextField(
              decoration: InputDecoration(hintText: "1,2,3,4,5"),
              // Use viewModel.inputText as controller value
            ),
            ElevatedButton(
              onPressed: () {
                // Call viewModel.pushDimensionData()
              },
              child: Text("Generate Dimension"),
            ),
            _DimensionInputRow(),
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

class _TopContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20,
      color: Colors.white,
      padding: EdgeInsets.all(3),
      child: Text(projectUrl),
    );
  }
}

class _DimensionInputRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text("Dimension"),
          SizedBox(width: 2),
          Container(
            width: 35,
            child: TextField(
              decoration: InputDecoration(hintText: "320"),
              // Use viewModel.dimenAdd as controller value
            ),
          ),
          SizedBox(width: 5),
          Text("Ratio"),
          SizedBox(width: 2),
          Container(
            width: 35,
            child: TextField(
              decoration: InputDecoration(hintText: "1.0"),
              // Use viewModel.ratioAdd as controller value
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Call addDimensionData() and handle duplicate alert
            },
            child: Text("Add more"),
          ),
        ],
      ),
    );
  }
}