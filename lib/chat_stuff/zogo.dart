import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/cloud_stuff/soft_firestore.dart';
import 'package:ebm_version_1_0/shared_stuff/messaging.dart';
import 'package:ebm_version_1_0/shared_stuff/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'pichadealer.dart';

class ZogoScreen extends StatefulWidget {
  final String jinaLake;
  final String emailYake;
  const ZogoScreen(
      {super.key, required this.jinaLake, required this.emailYake});

  @override
  State<ZogoScreen> createState() => _ZogoScreenState();
}

class _ZogoScreenState extends State<ZogoScreen> {
  TextEditingController kichatisho = TextEditingController();
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
  String? tokenYake;
  String? ohYeah;
  @override
  void initState() {
    initThatWaits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: someColor,
        foregroundColor: Colors.white,
        title: Text(widget.jinaLake),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ohYeah == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('zogo')
                            .doc(ohYeah)
                            .collection('jumbe')
                            .orderBy('muda', descending: true)
                            .snapshots(),
                        builder: (context, madini) {
                          if (madini.hasData) {
                            if ((madini.data as dynamic).docs.isEmpty) {
                              return const Center(
                                child: Text('Send request'),
                              );
                            } else {
                              return HapaKati(
                                jumbe: (madini.data as dynamic).docs,
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )),
            TextField(
              controller: kichatisho,
              maxLines: null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Ujumbe',
                  suffixIcon: IconButton(
                      onPressed: () async {
                        if (kichatisho.text.isNotEmpty) {
                          if (ohYeah == 'no-shit') {
                            try {
                              //ongeza wahusika
                              var uhusika = await FirebaseFirestore.instance
                                  .collection('zogo')
                                  .add({
                                'wahusika': [mimi, widget.emailYake]
                              });
                              //weka ujumbe
                              await uhusika.collection('jumbe').add({
                                'ujumbe': kichatisho.text,
                                'url': null,
                                'mtumaji': jinaLangu,
                                'mpokeaji': widget.jinaLake,
                                'muda': DateTime.now()
                              });
                              kichatisho.clear();
                              initThatWaits();
                              //send a direct notification
                              if (tokenYake != null) {
                                await Messaging.sendTo(
                                    title: softtitle,
                                    body: 'Rudi kwneye app, una ujumbe mpya',
                                    kwenda: tokenYake!);
                              }
                            } catch (shida) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(shida.toString())));
                            }
                          } else {
                            try {
                              FirebaseFirestore.instance
                                  .collection('zogo')
                                  .doc(ohYeah)
                                  .collection('jumbe')
                                  .add({
                                'ujumbe': kichatisho.text,
                                'url': null,
                                'mtumaji': jinaLangu,
                                'mpokeaji': widget.jinaLake,
                                'muda': DateTime.now()
                              });
                              kichatisho.clear();
                              if (tokenYake != null) {
                                await Messaging.sendTo(
                                    title: softtitle,
                                    body: 'Rudi kwneye app, una ujumbe mpya',
                                    kwenda: tokenYake!);
                              }
                            } catch (shida) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(shida.toString())));
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.send)),
                  prefixIcon: IconButton(
                      onPressed: () async {
                        var picha = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (picha != null) {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TumaPicha(
                                    picha: picha,
                                    emailYake: widget.emailYake,
                                    jinaLake: jinaLangu!,
                                    ohYeah: ohYeah!,
                                  )));
                          initThatWaits();
                        }
                      },
                      icon: const Icon(Icons.attach_file))),
            )
          ],
        ),
      ),
    );
  }

  initThatWaits() async {
    ohYeah = await SoftFire().areWe(mimi!, widget.emailYake);
    await FirebaseFirestore.instance
        .collection(eBMUCollection)
        .doc(widget.emailYake)
        .get()
        .then((value) {
      if (value.exists) {
        tokenYake = value.data()?[softtokey];
      }
    });
    setState(() {});
  }
}

class HapaKati extends StatelessWidget {
  final jumbe;
  const HapaKati({super.key, required this.jumbe});

  @override
  Widget build(BuildContext context) {
    String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
    return ListView.builder(
      itemCount: jumbe.length,
      reverse: true,
      itemBuilder: (context, hii) {
        return Row(
          mainAxisAlignment: jumbe[hii]['mtumaji'] == jinaLangu
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              constraints: const BoxConstraints(
                  minHeight: kBottomNavigationBarHeight,
                  minWidth: kBottomNavigationBarHeight,
                  maxWidth: 300),
              decoration: BoxDecoration(
                  color: somerColor, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  jumbe[hii]['url'] != null
                      ? Image.network(jumbe[hii]['url'])
                      : const SizedBox(),
                  Text(
                    jumbe[hii]['ujumbe'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class ThreadZote extends StatefulWidget {
  const ThreadZote({super.key});

  @override
  State<ThreadZote> createState() => _ThreadZoteState();
}

class _ThreadZoteState extends State<ThreadZote> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: someColor,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text('Conversations'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('zogo')
            .where('wahusika', arrayContains: mimi)
            .snapshots(),
        builder: (context, madini) {
          if (madini.hasData) {
            if ((madini.data as dynamic).docs.isEmpty) {
              return const Center(
                child: Text('You have not Chats yet'),
              );
            }
            return ListView.builder(
                itemCount: (madini.data as dynamic).docs.length,
                itemBuilder: (context, index) {
                  for (var mhusika in (madini.data as dynamic).docs[index]
                      ['wahusika']) {
                    if (mhusika != mimi) {
                      return KaOneThreadTile(
                        emailYake: mhusika,
                        id: (madini.data as dynamic).docs[index].id,
                      );
                    }
                  }
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class KaOneThreadTile extends StatelessWidget {
  final String id;
  final String emailYake;
  const KaOneThreadTile({super.key, required this.id, required this.emailYake});

  @override
  Widget build(BuildContext context) {
    String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('zogo')
          .doc(id)
          .collection('jumbe')
          .orderBy('muda', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: ListTile(
              tileColor: somerColor,
              contentPadding: const EdgeInsets.only(left: 16),
              title: (snapshot.data as dynamic).docs[0]['mtumaji'] == jinaLangu
                  ? Text((snapshot.data as dynamic).docs[0]['mpokeaji'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis)
                  : Text((snapshot.data as dynamic).docs[0]['mtumaji'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
              subtitle: Text((snapshot.data as dynamic).docs[0]['ujumbe'],
                  overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert)),
              onTap: () {
                if ((snapshot.data as dynamic).docs[0]['mtumaji'] !=
                    jinaLangu) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ZogoScreen(
                          jinaLake: (snapshot.data as dynamic).docs[0]
                              ['mtumaji'],
                          emailYake: emailYake)));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ZogoScreen(
                          jinaLake: (snapshot.data as dynamic).docs[0]
                              ['mpokeaji'],
                          emailYake: emailYake)));
                }
              },
            ),
          );
        }
        return const ListTile();
      },
    );
  }
}
