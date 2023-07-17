import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/shared_stuff/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class TumaPicha extends StatefulWidget {
  final XFile picha;
  final String ohYeah;
  final String emailYake;
  final String jinaLake;
  const TumaPicha(
      {super.key,
      required this.picha,
      required this.ohYeah,
      required this.emailYake,
      required this.jinaLake});
  @override
  State<TumaPicha> createState() => _TumaPichaState();
}

class _TumaPichaState extends State<TumaPicha> {
  TextEditingController nina = TextEditingController();
  TextEditingController maelezomafupi = TextEditingController();
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
  bool amUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Attachment'),
        backgroundColor: Colors.black,
        actions: [
          const SizedBox(width: 16),
          !amUploading
              ? IconButton(
                  onPressed: theGeneralProcess, icon: const Icon(Icons.send))
              : const CircularProgressIndicator()
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          TextField(
            controller: nina,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: someColor,
                hintText: 'Name of the exchange item',
                hintStyle: const TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: maelezomafupi,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: someColor,
                hintText: 'Description about exchange item',
                hintStyle: const TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: FileImage(File(widget.picha.path)))),
          ),
        ],
      ),
    );
  }

  theGeneralProcess() async {
    var refYaPicha = FirebaseStorage.instance
        .ref()
        .child("attachments/${const Uuid().v1()}");
    try {
      setState(() {
        amUploading = true;
      });
      await refYaPicha.putFile(File(widget.picha.path));
      String pichaUrl = await refYaPicha.getDownloadURL();
      await subTextingProcess(pichaUrl);
      setState(() {
        amUploading = false;
      });
    } catch (shida) {
      setState(() {
        amUploading = false;
      });
      print(shida);
    }
  }

  subTextingProcess(String yuarel) async {
    String ujumbe =
        'Habari, kwa majina naitwa: $jinaLangu, nina miliki ${nina.text} ningependa kufanya mabadilishano nawe, na haya ni maelezo mafupi: ${maelezomafupi.text}';
    if (widget.ohYeah == 'no-shit') {
      try {
        //ongeza wahusika
        var uhusika = await FirebaseFirestore.instance.collection('zogo').add({
          'wahusika': [mimi, widget.emailYake]
        });
        //weka ujumbe
        await uhusika.collection('jumbe').add({
          'ujumbe': ujumbe,
          'url': yuarel,
          'mtumaji': jinaLangu,
          'mpokeaji': widget.jinaLake,
          'muda': DateTime.now()
        });
      } catch (shida) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(shida.toString())));
      }
    } else {
      try {
        FirebaseFirestore.instance
            .collection('zogo')
            .doc(widget.ohYeah)
            .collection('jumbe')
            .add({
          'ujumbe': ujumbe,
          'url': yuarel,
          'mtumaji': jinaLangu,
          'mpokeaji': widget.jinaLake,
          'muda': DateTime.now()
        });
      } catch (shida) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(shida.toString())));
      }
    }
  }
}
