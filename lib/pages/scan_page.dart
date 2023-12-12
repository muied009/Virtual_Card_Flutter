import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  static const String routeName = "/scan";
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanOver = false;
  List<String> lines = [];
  String name = "", mobile = "", email = "", address = "", companyName = "",
      designation = "", website = "", imagePath = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : const Text("Scan"),
        elevation: 1,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(onPressed: (){getImage(ImageSource.camera);}, icon: const Icon(Icons.camera_alt), label: const Text("Capture")),
              TextButton.icon(onPressed: (){getImage(ImageSource.gallery);}, icon: const Icon(Icons.photo), label: const Text("Gallery"))
            ],
          ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 10,
            children: lines.map((line) => LineItem(line: line)).toList()
          )
        ],
      ),
    );
  }

  void getImage(ImageSource source) async{
    final xFile = await ImagePicker().pickImage(source: source);
    if ( xFile != null ) {
      imagePath = xFile.path;

      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      ///recongnizedText er vitore list of block pabo , protita block e line ar protita line e charecter pabo
      final recongnizedText = await textRecognizer
          .processImage(InputImage.fromFile(File(imagePath)));

      final tempList = <String>[];
      for (var block in recongnizedText.blocks){
        for (var line in block.lines){
          tempList.add(line.text);
        }
      }

      setState(() {
        lines = tempList;
        isScanOver = true;
      });
      print("jkjk$lines");
    }
  }
}

class LineItem extends StatelessWidget {
  final String line;
  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final GlobalKey _globalKey = GlobalKey();
    return LongPressDraggable(
      data: line,
        dragAnchorStrategy: childDragAnchorStrategy,
        feedback: Container(
          key: _globalKey,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(line,style: Theme.of(context)
              .textTheme.titleMedium!.copyWith(color: Colors.white),),
        ),
      child: Chip(label: Text(line),),
    );
  }
}

