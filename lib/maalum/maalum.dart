import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/shared_stuff/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Exchangables extends StatelessWidget {
  Exchangables({super.key});
  final String? emailYangu = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection(collectionYaPosts).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var exchangables = (snapshot.data as dynamic).docs;
          List<String> offersZilizopo = [];
          List<String> demands = [];
          List<String> wenyewe = [];
          for (var oneDoc in exchangables) {
            demands.add(oneDoc[postWishing]);
          }
          for (var oneDoc in exchangables) {
            offersZilizopo.add(oneDoc[postOffer]);
          }
          for (var oneDoc in exchangables) {
            wenyewe.add(oneDoc[posterer]);
          }
          // return StanleyAi(demands: demands, offerss: offersZilizopo);
          return RobertWan(
              offa: offersZilizopo, demands: demands, wenyewe: wenyewe);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class StanleyAi extends StatefulWidget {
  final List<String> demands;
  final List<String> offerss;
  const StanleyAi({super.key, required this.demands, required this.offerss});

  @override
  State<StanleyAi> createState() => _StanleyAiState();
}

class _StanleyAiState extends State<StanleyAi> {
  final openAI = OpenAI.instance.build(
      token: tokenYaAI,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 90)));
  String? emailYangu = FirebaseAuth.instance.currentUser?.email;
  List<Map<String, String>> threads = [];
  var whatAYoffer;
  var interest;

  @override
  void initState() {
    print(widget.offerss);
    threads.add(Map.of({
      "role": "system",
      "content":
          "this${widget.offerss} is a list of barter trade offers in this system's database, memorize it because in a moment this app's user is going to tell you what they need so as to exchange for what they have and you are going to help them with the matching, for now Just introduce yourself as GodWan, an AI assistant for this app and that you are here to help in their bartering process, ask them to click button at the bottom so you can help them auto-match their needs with actual items available (your suggestion should trictly abide with what is in the list before)"
    }));
    kuScanCoinC();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: someGreen,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: somerGreen,
        titleSpacing: 0,
        title: const Text('AI Assistant'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton.icon(
          onPressed: () {
            print('i offer the following $whatAYoffer');
            if (threads.length > 2) {
              threads.removeLast();
              threads.add(Map.of({
                "role": "user",
                "content":
                    "Hey, Godwan, i am looking for $interest, i notice you already know items available in the database, help me datermine if what i want for exchange is available, if yes tell me the specifics if not suggest any other item in the database that is cool in a clear list form"
              }));
            } else {
              threads.add(Map.of({
                "role": "user",
                "content":
                    "Hey, Godwan, i am looking for $interest, i notice you already know items available in the database, help me datermine if what i want for exchange is available, if yes tell me the specifics if not suggest any other item in the database that is cool in a clear list form"
              }));
            }
            kuScanCoinC();
          },
          icon: const Icon(Icons.rocket),
          label: const Text('auto-match'),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(eBMUCollection)
            .doc(FirebaseAuth.instance.currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data as dynamic).data()['nahitaji'].isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LottieBuilder.asset('softtools/prosholder.json'),
                    const SizedBox(
                      width: 250,
                      child: Text(
                        'Tell us what you are interested with',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              );
            }
            interest = (snapshot.data as dynamic).data()['nahitaji'];
            return ListView.builder(
              itemCount: threads.length,
              itemBuilder: (context, index) {
                if (threads.length == 1) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (index == 0) {
                  return const SizedBox();
                }
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          threads[index]['content']!,
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ));
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  kuScanCoinC() async {
    final request = ChatCompleteText(
        messages: threads,
        maxToken: 3000,
        temperature: 1,
        model: ChatModel.chatGptTurbo0301Model);
    try {
      var cTJibu = await openAI.onChatCompletion(request: request);
      String? jibu =
          cTJibu?.choices.last.message?.content ?? 'This is going bad';
      if (threads.length > 2) {
        threads.removeLast();
        threads.add(Map.of({"role": "assistant", "content": jibu}));
      } else {
        threads.add(Map.of({"role": "assistant", "content": jibu}));
      }
      setState(() {});
    } catch (shida) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(shida.toString())));
    }
  }
}

class RobertWan extends StatefulWidget {
  final List<String> offa;
  final List<String> demands;
  final List<String> wenyewe;
  const RobertWan(
      {super.key,
      required this.offa,
      required this.demands,
      required this.wenyewe});

  @override
  State<RobertWan> createState() => _RobertWanState();
}

class _RobertWanState extends State<RobertWan> {
  final openAI = OpenAI.instance.build(
      token: tokenYaAI,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 90)));
  TextEditingController? fomCont;
  bool nafetchMambo = false;

  List<Map<String, String>> maongezi = [];

  @override
  void initState() {
    int i = 0;
    // String sistem = "";
    // for (var mwenyewe in widget.wenyewe) {
    //   sistem = sistem +
    //       " someone with " +
    //       widget.offa[i] +
    //       " is looking for " +
    //       widget.demands[i] +
    //       ", ";
    //   i++;
    // }
    maongezi.add(Map.of({
      "role": "system",
      "content":
          "Hey,you are AI assitant in this app and${widget.offa} is a list of offers we currently have this app's database, each one of those requires one of ${widget.demands} as per the exact order, this is a preliminary system info of our system, so just start by introducing yourself as RobertWan an AI assistant in this app to help matching coincidence of wants in barter trade on this online platform"
    }));
    fomCont = TextEditingController();
    robertwaning(true);
    super.initState();
  }

  @override
  void dispose() {
    fomCont?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: someGreen,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: somerGreen,
          title: const Text('AI Co-Pilot'),
          titleSpacing: 0,
          actions: [
            IconButton(
                onPressed: () {
                  if (!nafetchMambo) {
                    setState(() {
                      maongezi.clear();
                    });
                  }
                },
                icon: const Icon(Icons.delete_sweep)),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: maongezi.length,
              itemBuilder: (context, hiihapa) {
                return hiihapa >= 1
                    ? Card(
                        color: someGreen,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hiihapa % 2 == 0
                                  ? const CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage('lib/vifaa/user.png'),
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage('lib/vifaa/robertwan.png'),
                                    ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      maongezi[hiihapa]['content']!,
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            )),
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
              color: someGreen,
              child: TextField(
                controller: fomCont,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(30)),
                    hintText: 'Ask me to find what you want',
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                    suffixIcon: nafetchMambo
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              robertwaning(false);
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ))),
              ),
            )
          ],
        ));
  }

  robertwaning(bool isInit) async {
    setState(() {
      nafetchMambo = true;
      if (!isInit) {
        maongezi.add(Map.of({"role": "user", "content": fomCont!.text}));
      }
    });
    final request = ChatCompleteText(
        messages: maongezi,
        maxToken: 2000,
        model: ChatModel.chatGptTurbo0301Model);
    print(maongezi.length);
    try {
      final response = await openAI.onChatCompletion(request: request);
      setState(() {
        nafetchMambo = false;
        fomCont!.clear();
        String content = response!.choices.first.message!.content;
        maongezi.add(Map.of({"role": "assistant", "content": content}));
      });
    } catch (shida) {
      setState(() {
        nafetchMambo = false;
        maongezi.removeLast();
      });
      mjumbe('Shida ya kiufundi imejitokeza, Jaribu baada ya muda');
      print('shida ni: ${shida.toString()}');
      return;
    }
  }

  mjumbe(String ujumbe) {
    print(ujumbe);
  }
}
