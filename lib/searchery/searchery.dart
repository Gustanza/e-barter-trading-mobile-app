import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/nyumbani.dart';
import 'package:ebm_version_1_0/shared_stuff/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mtafutaji extends StatefulWidget {
  final String nilipo;
  const Mtafutaji({super.key, required this.nilipo});

  @override
  State<Mtafutaji> createState() => _MtafutajiState();
}

class _MtafutajiState extends State<Mtafutaji> {
  String? emailYangu = FirebaseAuth.instance.currentUser?.email;
  TextEditingController searcherCon = TextEditingController();
  FirebaseFirestore objYaSto = FirebaseFirestore.instance;
  bool nowSearching = false;
  var deita;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 75,
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          backgroundColor: someColor,
          title: TextField(
            controller: searcherCon,
            onChanged: (value) {
              if (searcherCon.text.isNotEmpty) {
                setState(() {
                  nowSearching = true;
                });
              } else {
                setState(() {
                  nowSearching = false;
                });
              }
            },
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white)),
                hintText: 'Tafuta bidhaa',
                hintStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
        ),
        body: nowSearching
            ? FutureBuilder(
                future: objYaSto
                    .collection(collectionYaPosts)
                    .where(postOffer,
                        isGreaterThanOrEqualTo: searcherCon.text.toLowerCase())
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = (snapshot.data as dynamic).docs;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          if (data[index][postMkoa] == widget.nilipo) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  deita = data[index];
                                  nowSearching = false;
                                  searcherCon.clear();
                                });
                                FocusScope.of(context).unfocus();
                              },
                              tileColor: somerColor,
                              title: Text(
                                data[index][postOffer],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(data[index][offerCat]),
                            );
                          }
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : Container(
                child: deita == null
                    ? const Center(child: Text('Tafuta bidhaa kwa urahisi'))
                    : ListView(children: [
                        RamaniYaPost(data: deita, emailYangu: emailYangu!)
                      ]),
              ));
  }
}
