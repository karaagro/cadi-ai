import 'package:cadi_ai/utils/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cadi_ai/Utils/strings.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutLayout extends StatefulWidget {
  const AboutLayout({super.key});

  @override
  State<AboutLayout> createState() => _AboutLayoutState();
}

class _AboutLayoutState extends State<AboutLayout> {
  // Order of key-value-pairs in the map below is important.
  static const Map<String, String> aboutTextNamesAndUrls = {
    "KaraAgro AI": "https://www.karaagro.com/",
    "Market-Oriented Value Chains for Jobs & Growth in the ECOWAS Region (MOVE/Comcashew)":
        "https://www.giz.de/en/worldwide/108524.html",
    "FAIR Forward - Artificial Intelligence for All":
        'https://toolkit-digitalisierung.de/en/fair-forward/',
    "KaraAgro’s GitHub.": "https://github.com/karaagro/ai4cashew-open-source"
  };

  createTextWidget(text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.white60),
    );
  }

  createHyperLink(String text, String url) {
    return TextSpan(
        text: text,
        style: const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrlString(url);
          });
  }

  Widget constructAboutTextList() {
    String remainderTextAfterSplit = ABOUT_APP;
    List<TextSpan> aboutWidgets = [];

    for (String key in aboutTextNamesAndUrls.keys) {
      List<String> splitText = remainderTextAfterSplit.split(key);
      aboutWidgets.addAll([
        createTextWidget(splitText[0]),
        createHyperLink(key, aboutTextNamesAndUrls[key]!)
      ]);
      remainderTextAfterSplit = splitText[1];
    }
    aboutWidgets.add(createTextWidget(remainderTextAfterSplit));

    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: RichText(
          text: TextSpan(children: aboutWidgets),
          textAlign: TextAlign.justify,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AppConfig.getVersion(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.hasData) {
            final version = snapshot.data!;

            return Scaffold(
                body: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                            width: 300,
                            height: 300,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 50, bottom: 10),
                                child: Image(
                                    alignment: Alignment.topCenter,
                                    image: AssetImage('assets/cashew.png')))),
                        Expanded(
                            child: ListView(children: [
                          Column(children: [
                            Row(children: [
                              Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    "CADI AI V$version",
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white70),
                                    textAlign: TextAlign.left,
                                  ))
                            ]),
                            constructAboutTextList()
                          ])
                        ]))
                      ],
                    )));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
