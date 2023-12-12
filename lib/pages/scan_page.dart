import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visiting_card/utils/constants.dart';

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
         if(isScanOver)  Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DropTargetItem(property: ContactProperties.name, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperties.designation, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperties.companyName, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperties.address, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperties.email, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperties.mobile, onDrop: _getPropertyValue),
                  DropTargetItem(property: ContactProperties.website, onDrop: _getPropertyValue),
                ],
              ),
            ),
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

  _getPropertyValue(String property, String value) {
  }
}

class DropTargetItem extends StatefulWidget {
  final String property;
  final Function onDrop;
  const DropTargetItem({super.key, required this.property, required this.onDrop});

  @override
  State<DropTargetItem> createState() => _DropTargetItemState();
}

class _DropTargetItemState extends State<DropTargetItem> {
  String draggedItem = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(widget.property)),
        Expanded(
          flex: 2,
          child: DragTarget<String>(
              builder: (context,candidateData, rejectedData) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: candidateData.isNotEmpty ? Border.all(color: Colors.red,width: 2) : null,
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(draggedItem.isEmpty ? "Drop Here" : draggedItem)),
                    if (draggedItem.isNotEmpty)
                      InkWell(
                        onTap: (){
                          setState(() {
                            draggedItem = "";
                          });
                        },
                          child: const Icon(Icons.clear, size: 15))
                  ],
                ),
              ),
            onAccept: (value){
                setState(() {
                  if(draggedItem.isEmpty){
                    draggedItem = value;
                  }else{
                    draggedItem += " $value";
                  }
                });
                widget.onDrop(widget.property,draggedItem);
            },
          ),
        )
      ],
    );
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

