import 'package:cadi_ai/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:cadi_ai/utils/strings.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutLayout extends StatefulWidget {
  const AboutLayout({super.key});

  // Order of key-value-pairs in the map below is important.
  static const Map<String, String> aboutTextNamesAndUrls = {
    "KaraAgro AI": "https://www.karaagro.com/",
    "FAIR Forward - Artificial Intelligence for All":
        'https://toolkit-digitalisierung.de/en/fair-forward/'
  };

  createTextWidget(text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white60),
      ),
    );
  }

  createHyperLink(text, url) {
    return InkWell(
        child: Text(
          text,
          style: const TextStyle(color: Colors.lightBlue),
        ),
        onTap: () => launchUrlString(url));
  }

  List<Widget> constructAboutTextList() {
    String remainderTextAfterSplit = ABOUT_APP;
    List<Widget> aboutWidgets = [];

    for (String key in aboutTextNamesAndUrls.keys) {
      List<String> splitText = remainderTextAfterSplit.split(key);
      aboutWidgets.add(createTextWidget(splitText[0]));
      aboutWidgets.add(createHyperLink(key, aboutTextNamesAndUrls[key]!));
      remainderTextAfterSplit = splitText[1];
    }
    aboutWidgets.add(createTextWidget(remainderTextAfterSplit));
    return aboutWidgets;
  }

  @override
  State<AboutLayout> createState() => _AboutLayoutState();
}

class _AboutLayoutState extends State<AboutLayout> {
  // Order of key-value-pairs in the map below is important.
  static const Map<String, String> aboutTextNamesAndUrls = {
    "KaraAgro AI": "https://www.karaagro.com/",
    "FAIR Forward - Artificial Intelligence for All":
        'https://toolkit-digitalisierung.de/en/fair-forward/',
    "KaraAgro’s GitHub.": "https://github.com/karaagro/ai4cashew-open-source"
  };

  createTextWidget(text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white60),
      ),
    );
  }

  createHyperLink(text, url) {
    return InkWell(
        child: Text(
          text,
          style: const TextStyle(color: Colors.lightBlue),
        ),
        onTap: () => launchUrlString(url));
  }

  List<Widget> constructAboutTextList() {
    String remainderTextAfterSplit = ABOUT_APP;
    List<Widget> aboutWidgets = [];

    for (String key in aboutTextNamesAndUrls.keys) {
      List<String> splitText = remainderTextAfterSplit.split(key);
      aboutWidgets.add(createTextWidget(splitText[0]));
      aboutWidgets.add(createHyperLink(key, aboutTextNamesAndUrls[key]!));
      remainderTextAfterSplit = splitText[1];
    }
    aboutWidgets.add(createTextWidget(remainderTextAfterSplit));
    return aboutWidgets;
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
                      children: [
                        const SizedBox(
                            width: 300,
                            child: Image(
                                alignment: Alignment.topCenter,
                                image: AssetImage('assets/cashew.png'))),
                        Expanded(
                            child: ListView(children: [
                          Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "CADI AI V$version",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white70),
                                  textAlign: TextAlign.center,
                                )),
                            ...constructAboutTextList()
                          ])
                        ]))
                      ],
                    )));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
