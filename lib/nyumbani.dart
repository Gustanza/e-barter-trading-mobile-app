import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/chat_stuff/zogo.dart';
import 'package:ebm_version_1_0/maalum/maalum.dart';
import 'package:ebm_version_1_0/mipangilio/mipangilio.dart';
import 'package:ebm_version_1_0/searchery/searchery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'shared_stuff/variables.dart';

class ControllerWaFeed extends StatelessWidget {
  ControllerWaFeed({super.key});
  final String? emailYangu = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(eBMUCollection)
          .doc(emailYangu)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data as dynamic).data() != null) {
            String nilipo = (snapshot.data as dynamic).data()[lokesheni];
            return PageMain(
              nilipo: nilipo,
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class PageMain extends StatefulWidget {
  final String nilipo;
  const PageMain({super.key, required this.nilipo});

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  String? emailYangu = FirebaseAuth.instance.currentUser?.email;
  List<String> valueZaFilter = [catZote, umriZote];
  List<String> catsNahitaji = [zoazoa];
  List<String> vituNahitaji = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: someColor,
        foregroundColor: Colors.white,
        title: Text(softtitle),
        actions: [
          IconButton(
              onPressed: kutokaNje,
              icon: const Icon(
                Icons.logout,
                size: 35,
              ))
        ],
      ),
      drawer: baharia(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Mtafutaji(nilipo: widget.nilipo)));
        },
        backgroundColor: someColor,
        child: const Icon(Icons.search),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: kToolbarHeight,
            color: someColor,
            child: ListView.builder(
                itemCount: opshenFilter.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1.5, color: Colors.white)),
                      child: DropdownButton(
                        alignment: Alignment.center,
                        iconEnabledColor: Colors.white,
                        underline: const SizedBox(),
                        hint: Text(
                          valueZaFilter[index],
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        dropdownColor: somerColor,
                        items: List.generate(
                            opshenFilter[index].length,
                            (indexingine) => DropdownMenuItem(
                                value: opshenFilter[index][indexingine],
                                child: Text(opshenFilter[index][indexingine]))),
                        onChanged: (iliyoguzwa) {
                          setState(() {
                            valueZaFilter[index] = iliyoguzwa!;
                          });
                        },
                      ));
                }),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(collectionYaPosts)
                .where(postMkoa, isEqualTo: widget.nilipo)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var madocuments = (snapshot.data! as dynamic).docs;
              for (var documentmoja in madocuments) {
                if (documentmoja[postererMail] == emailYangu) {
                  if (!catsNahitaji.contains(documentmoja[wishCat])) {
                    catsNahitaji.add(documentmoja[wishCat]);
                  }
                  if (!vituNahitaji.contains(documentmoja[postWishing])) {
                    vituNahitaji.add(documentmoja[postWishing]);
                  }
                }
              }

              madocuments = filterer(madocuments);
              return Expanded(
                child: ListView.builder(
                    itemCount: madocuments.length,
                    itemBuilder: (context, index) {
                      var data = madocuments[index];
                      return RamaniYaPost(
                        data: data,
                        emailYangu: emailYangu!,
                      );
                    }),
              );
            },
          ),
        ],
      ),
    );
  }

  filterer(var madocument) {
    var maDoc = [];
    for (var documentmoja in madocument) {
      maDoc.add(documentmoja);
    }
    if (valueZaFilter[0] != catZote) {
      for (var docMoja in madocument) {
        if (docMoja[offerCat] != valueZaFilter[0]) {
          maDoc.remove(docMoja);
        }
      }
    }
    if (valueZaFilter[1] != umriZote) {
      for (var docMoja in madocument) {
        if (docMoja[offerage] != valueZaFilter[1]) {
          maDoc.remove(docMoja);
        }
      }
    }
    return maDoc;
  }

  baharia() {
    return Drawer(
      backgroundColor: somerColor,
      child: ListView(
        children: [
          Card(
            color: softonian,
            child: ListTile(
              title: Text(
                softtitle,
                style: TextStyle(
                    color: someColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              selected: true,
              selectedTileColor: someGreen,
              title: const Text(
                'Home',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          const Divider(thickness: 2, height: 2),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Exchangables()));
              },
              title: const Text(
                'AI Co-Pilot',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          const Divider(thickness: 2, height: 2),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ThreadZote()));
              },
              title: const Text(
                'Conversations',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          const Divider(thickness: 2, height: 2),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Mipangilio()));
              },
              title: const Text(
                'Account',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          const Divider(thickness: 2, height: 2),
        ],
      ),
    );
  }

  kutokaNje() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to log-out?'),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  popeye();
                },
                icon: const Icon(
                  Icons.check_circle,
                  size: 40,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.cancel,
                  size: 40,
                  color: Colors.red,
                ))
          ],
        );
      },
    );
  }

  popeye() {
    Navigator.of(context).pop();
  }
}

class RamaniYaPost extends StatelessWidget {
  var data;
  String emailYangu;
  RamaniYaPost({super.key, required this.data, required this.emailYangu});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 4, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => UzamivuWaPost(
                          data: data,
                        ))));
              },
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(data[postAd]), fit: BoxFit.cover)),
                alignment: Alignment.topLeft,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  data[postOffer],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Image.asset('softtools/1.png', height: 25),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data[postWishing],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Text(
              data[postDesc],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
            FilledButton.icon(
              onPressed: () {
                if (data[postererMail] != emailYangu) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ZogoScreen(
                            jinaLake: data[posterer],
                            emailYake: data[postererMail],
                          )));
                }
              },
              icon: const Icon(Icons.person_4),
              label: data[postererMail] != emailYangu
                  ? const Text('Send request')
                  : const Text('Wait request'),
            ),
          ],
        ),
      ),
    );
  }
}

class UzamivuWaPost extends StatefulWidget {
  var data;
  UzamivuWaPost({super.key, required this.data});

  @override
  State<UzamivuWaPost> createState() => _UzamivuWaPostState();
}

class _UzamivuWaPostState extends State<UzamivuWaPost> {
  String? emailYangu = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: someColor,
          foregroundColor: Colors.white,
          title: Text(widget.data[postOffer]),
        ),
        body: ListView(
          children: [
            Container(
                height: 350,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.data[postAd]),
                        fit: BoxFit.cover)),
                alignment: Alignment.topLeft),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data[offerCat],
                    style: TextStyle(
                        fontSize: 28,
                        color: someColor,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Nina ${widget.data[postOffer]} ninahitaji ${widget.data[postWishing]}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.place,
                        color: Colors.black54,
                      ),
                      Text(widget.data[postMkoa],
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.data[postDesc],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    height: kToolbarHeight,
                    decoration: BoxDecoration(
                        color: someColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        if (widget.data[postererMail] != emailYangu) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ZogoScreen(
                                    jinaLake: widget.data[posterer],
                                    emailYake: widget.data[postererMail],
                                  )));
                        }
                      },
                      child: const Text(
                        'wasiliana nami',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.data[postererMail],
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            )
          ],
        ));
  }
}
