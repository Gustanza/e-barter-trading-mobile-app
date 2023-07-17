import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/akaunti_stuff/page_kabla_ya_kupost.dart';
import 'package:ebm_version_1_0/shared_stuff/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Mipangilio extends StatefulWidget {
  const Mipangilio({super.key});

  @override
  State<Mipangilio> createState() => _MipangilioState();
}

class _MipangilioState extends State<Mipangilio> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  TextEditingController jinaCon = TextEditingController();
  TextEditingController prefCon = TextEditingController();
  bool sifanyiKitu = true;
  CroppedFile? croppedFile;
  XFile? softPicked;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: someColor,
          foregroundColor: Colors.white,
          title: const Text('Account'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(eBMUCollection)
              .doc(mimi)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'Profile information',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (snapshot.data as dynamic).data()[eBMUpicha]),
                        ),
                        title: const Text(
                          'Profile picture',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        trailing: sifanyiKitu
                            ? IconButton(
                                onPressed: setPicha,
                                icon: const Icon(Icons.forward))
                            : CircularProgressIndicator(
                                color: someColor,
                              ),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.account_circle_rounded,
                          size: 35,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).data()[eBMUname],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                            onPressed: haririJinaLog,
                            icon: const Icon(Icons.forward)),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.place,
                          size: 35,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).data()[lokesheni],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ScreenYaLocation()));
                            },
                            icon: const Icon(Icons.forward)),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.email,
                          size: 35,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).id,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.lock,
                              color: someColor,
                            )),
                      )),
                  GestureDetector(
                    onLongPress: () async {
                      var vtuZopo =
                          (snapshot.data as dynamic).data()['nahitaji'];
                      await kuRemovePref(vtuZopo);
                    },
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: someGreen,
                      title: const Text(
                        'Preferences',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      subtitle:
                          (snapshot.data as dynamic).data()['nahitaji'].isEmpty
                              ? const Text('Add preferences')
                              : Text((snapshot.data as dynamic)
                                  .data()['nahitaji']
                                  .toString()),
                      trailing: IconButton(
                          onPressed: () async {
                            var vtuNahtaj =
                                (snapshot.data as dynamic).data()['nahitaji'];
                            await kuAddPref(vtuNahtaj);
                          },
                          icon: const Icon(Icons.add_circle)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('Post your exchange-item now',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: Container(
                                height: 60,
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: someColor,
                                  borderRadius: BorderRadius.circular(20),
                                  shape: BoxShape.rectangle,
                                ),
                                child: IconButton(
                                    onPressed: () async {
                                      await softPhotoCap(false);
                                      softPhotoCapDone();
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      size: 35,
                                      color: Colors.white,
                                    )))),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: someColor,
                                borderRadius: BorderRadius.circular(20),
                                shape: BoxShape.rectangle,
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await softPhotoCap(true);
                                    softPhotoCapDone();
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 35,
                                    color: Colors.white,
                                  ))),
                        ),
                      ]),
                  const SizedBox(
                    height: 250,
                    child: MySheet(),
                  )
                ],
              ),
            );
          },
        ));
  }

  setPicha() async {
    final ImagePicker softPicker = ImagePicker();
    var source = ImageSource.gallery;
    var softPicked = await softPicker.pickImage(source: source);
    if (softPicked != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: softPicked.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Change Profile Picture',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          sifanyiKitu = false;
        });
        try {
          var idYaPicha = const Uuid().v1();
          var softSRef =
              FirebaseStorage.instance.ref().child("pichaZaProfile/$idYaPicha");

          await softSRef.putFile(File(croppedFile.path));
          String urlYaPicha = await softSRef.getDownloadURL();

          FirebaseFirestore.instance
              .collection(eBMUCollection)
              .doc(mimi)
              .update({eBMUpicha: urlYaPicha});
          setState(() {
            sifanyiKitu = true;
          });
        } catch (shida) {
          setState(() {
            sifanyiKitu = true;
          });
          print('shida iliyopo ni: $shida');
        }
      }
    }
  }

  haririJinaLog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              titlePadding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
              title: const Text('Edit Username'),
              content: TextField(
                controller: jinaCon,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection(eBMUCollection)
                          .doc(mimi)
                          .update({eBMUname: jinaCon.text});
                      Navigator.of(context).pop();
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
                    )),
              ],
            ));
  }

  kuAddPref(var prefzopo) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add preference'),
              content: TextField(
                controller: prefCon,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Add here'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      var prefZopour = prefzopo;
                      prefZopour.add(prefCon.text);
                      try {
                        FirebaseFirestore.instance
                            .collection(eBMUCollection)
                            .doc(mimi)
                            .update({'nahitaji': prefZopour});
                      } catch (shida) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(shida.toString())));
                      }
                      FocusScope.of(context).unfocus();
                      prefCon.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add')),
              ],
            ));
  }

  kuRemovePref(var vtuZopo) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content:
                  const Text('Do you want to remove last added preference'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      var vtuZopour = vtuZopo;
                      try {
                        vtuZopour.removeLast();
                        FirebaseFirestore.instance
                            .collection(eBMUCollection)
                            .doc(mimi)
                            .update({'nahitaji': vtuZopour});
                      } catch (shida) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(shida.toString())));
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Remove')),
              ],
            ));
  }

  softPhotoCap(bool cameraHuh) async {
    final ImagePicker softPicker = ImagePicker();
    var source = cameraHuh ? ImageSource.camera : ImageSource.gallery;
    softPicked = await softPicker.pickImage(source: source);
  }

  softPhotoCapDone() async {
    if (softPicked != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: softPicked!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: softtitle,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: softtitle,
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        moove();
      }
    }
  }

  moove() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: ((context) => PageKablaYaPostn(picha: croppedFile!))));
  }
}

class ScreenYaLocation extends StatefulWidget {
  const ScreenYaLocation({super.key});

  @override
  State<ScreenYaLocation> createState() => _ScreenYaLocationState();
}

class _ScreenYaLocationState extends State<ScreenYaLocation> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: someColor,
        foregroundColor: Colors.white,
        title: const Text('Choose location'),
      ),
      body: ListView.builder(
        itemCount: mikoa.length,
        padding: const EdgeInsets.only(left: 4, top: 2, right: 4),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 2.5)),
            child: ListTile(
              onTap: () {
                FirebaseFirestore.instance
                    .collection(eBMUCollection)
                    .doc(mimi)
                    .update({lokesheni: mikoa[index]});
                Navigator.of(context).pop();
              },
              title: Text(
                mikoa[index],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MySheet extends StatefulWidget {
  const MySheet({super.key});

  @override
  State<MySheet> createState() => _MySheetState();
}

class _MySheetState extends State<MySheet> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionYaPosts)
            .where(postererMail, isEqualTo: mimi)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data as dynamic).docs.isEmpty) {
              return const Center(
                child: Text('You haven\'t posted yet'),
              );
            }
            var data = (snapshot.data as dynamic).docs;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsZaItem(
                              data: data[index],
                            )));
                  },
                  onLongPress: () async {
                    await dialogYaKufuta(data[index].id);
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        border: Border.all(width: 8, color: someColor),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(data[index][postAd]),
                            fit: BoxFit.cover)),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: someColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        data[index][postOffer],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<void> dialogYaKufuta(String aidii) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              'Do you intend to delete this Ad?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection(collectionYaPosts)
                        .doc(aidii)
                        .delete();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes', style: TextStyle(fontSize: 16))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No', style: TextStyle(fontSize: 16))),
            ],
          );
        });
  }
}

class DetailsZaItem extends StatelessWidget {
  var data;
  DetailsZaItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(data[postOffer]),
      ),
      body: Column(
        children: [
          Expanded(child: Image.network(data[postAd])),
        ],
      ),
    );
  }
}
