import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/cloud_stuff/soft_firestore.dart';
import 'package:ebm_version_1_0/shared_stuff/messaging.dart';
import 'package:ebm_version_1_0/shared_stuff/post.dart';
import 'package:ebm_version_1_0/shared_stuff/variables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class PageKablaYaPostn extends StatefulWidget {
  final CroppedFile picha;
  const PageKablaYaPostn({super.key, required this.picha});

  @override
  State<PageKablaYaPostn> createState() => _PageKablaYaPostnState();
}

class _PageKablaYaPostnState extends State<PageKablaYaPostn> {
  final yuzor = FirebaseAuth.instance.currentUser?.displayName;
  final yemail = FirebaseAuth.instance.currentUser?.email;
  final softOBJ = FirebaseMessaging.instance;
  TextEditingController offerCon = TextEditingController();
  TextEditingController wishCon = TextEditingController();
  TextEditingController maelezoCon = TextEditingController();
  String katIhitajikayo = catIhitajikayour;
  String katItolewayo = catItolewayour;
  String umri = umree;
  String mkoaV = mkoaWaAv;
  bool napandisha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: someColor,
            title: const Text('Post')),
        body: ListView(
          padding: const EdgeInsets.only(left: 24, right: 24),
          children: [
            const SizedBox(height: 24),
            Icon(
              size: 50,
              color: someColor,
              Icons.check_circle,
            ),
            softMkour(mikoa),
            catItolewayo(cats),
            softAgeDropy(listYaUmri),
            softInput(
                offerCon, TextInputType.name, 'Name of exchange-item offered'),
            catIhitajikayo(cats),
            softInput(
                wishCon, TextInputType.name, 'Name of exchange-item needed'),
            softInput(maelezoCon, TextInputType.name,
                'Short description about the excahnge-item'),
            const SizedBox(
              height: 18,
            ),
            softSubmit(),
            const SizedBox(
              height: 18,
            ),
          ],
        ));
  }

  softInput(
      TextEditingController softcon, TextInputType nini, String softhint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: softcon,
        maxLines: null,
        keyboardType: nini,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: softhint),
      ),
    );
  }

  softSubmit() {
    return GestureDetector(
      onTap: () async {
        if (checker()) {
          String sahivi = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
          final post = Post(
              user: yuzor!,
              mkoa: mkoaV,
              offerkat: katItolewayo,
              umri: umri,
              offering: offerCon.text.toLowerCase(),
              wishkat: katIhitajikayo,
              wishing: wishCon.text.toLowerCase(),
              datePosted: sahivi,
              email: yemail!,
              postDesc: maelezoCon.text);

          setState(() {
            napandisha = true;
          });
          await SoftFire().heavyDuty(post, widget.picha);
          await notifigence();
          setState(() {
            napandisha = false;
          });
          rudi();
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: someColor, borderRadius: BorderRadius.circular(10)),
        child: napandisha
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                wasilishaPost,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }

  checker() {
    if (mkoaV == mkoaWaAv) {
      mjumbe('Choose region of exchange availability');
      return false;
    }
    if (katItolewayo == catItolewayour) {
      mjumbe('Choose category of exchange-item');
      return false;
    }
    if (umri == umree) {
      mjumbe('How long was the item used');
      return false;
    }
    if (offerCon.text.isEmpty) {
      mjumbe('What is the name of item offered');
      return false;
    }
    if (katIhitajikayo == catIhitajikayour) {
      mjumbe('Choose category of exchange-item');
      return false;
    }
    if (wishCon.text.isEmpty) {
      mjumbe('Tufahamishe jina la bidhaa unayohitaji');
      return false;
    }
    if (maelezoCon.text.isEmpty) {
      mjumbe('Toa maelezo mafupi juu ya bidhaa yako');
      return false;
    }
    return true;
  }

  mjumbe(String ujumbe) {
    final snackbar = SnackBar(content: Text(ujumbe));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  catIhitajikayo(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(katIhitajikayo),
      dropdownColor: somerColor,
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          katIhitajikayo = iliyoguzwa!;
        });
      },
    );
  }

  catItolewayo(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(katItolewayo),
      dropdownColor: somerColor,
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          katItolewayo = iliyoguzwa!;
        });
      },
    );
  }

  softAgeDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(umri),
      dropdownColor: somerColor,
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          umri = iliyoguzwa!;
        });
      },
    );
  }

  softMkour(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(mkoaV),
      dropdownColor: somerColor,
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          mkoaV = iliyoguzwa!;
        });
      },
    );
  }

  Future<void> notifigence() async {
    try {
      int ninachohitaji = cats.indexOf(katIhitajikayo);
      int nilichonacho = cats.indexOf(katItolewayo);
      await softOBJ.subscribeToTopic(ninachohitaji.toString());
      await Messaging.sendTo(
          title: softtitle,
          body:
              'Hello, ${offerCon.text} imewekwa sokoni siyo muda,ingia kwenye app ujionee',
          kwenda: '/topics/$nilichonacho');
    } catch (shida) {
      mjumbe(shida.toString());
    }
  }

  rudi() {
    mjumbe('Hongera, bidhaa imewekwa sokoni kikamilifu');
    Navigator.of(context).pop();
  }
}
