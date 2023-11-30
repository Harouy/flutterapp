import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet/providers/language_provider.dart';

import 'choix.dart';
import 'models/Language.dart';

class Main extends ConsumerStatefulWidget {
  @override
  ConsumerState<Main> createState() {
    return _MainState();
  }
}

class _MainState extends ConsumerState<Main> {
  void navigate() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => CHOIX())));
  }

  @override
  void initState() {
    super.initState();
    // Trigger the language selection dialog when the app is first launched
    super.initState();
    // Add a delay to show the language selection dialog after the widget is built
    Future.delayed(Duration.zero, () {
      showLanguageSelectionDialog();
    });
  }

  Future<void> showLanguageSelectionDialog() async {
    final selectedLanguage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choisir la langue"),
          backgroundColor: Color.fromARGB(255, 32, 11, 110),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16.0), // Adjust the value as needed
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  "Français",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pop("fr"); // Return "fr" when French is selected
                },
              ),
              ListTile(
                title: Text("Arabe",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onTap: () {
                  Navigator.of(context)
                      .pop("ar"); // Return "ar" when Arabic is selected
                },
              ),
            ],
          ),
        );
      },
    );

    if (selectedLanguage != null) {
      // Set the selected language in the provider
      ref.read(translationProvider.notifier).changeLanguage(selectedLanguage);
    }
  }

  @override
  Widget build(context) {
    final translationModel = ref.watch(translationProvider);

    print(translationModel);

    // TODO: implement build
    var supportedLanguages = ["ar", "fr"];
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 196, 198, 199), // Background color for the whole page

      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 66, 13, 82),
          title: Text(
              ref.watch(translationProvider.notifier).translate("hello") +
                  " " +
                  ref.watch(translationProvider.notifier).translate("a") +
                  " " +
                  ref.watch(translationProvider.notifier).translate("chehal")),
          actions: [
            // Language Dropdown Button in AppBar
            IconButton(
              icon: Icon(Icons.language),
              onPressed: () {
                showLanguageSelectionDialog(); // Show language selection dialog
              },
            ),
          ]),
      body: SafeArea(
        child: Column(
          children: [
            // The top rectangle with circular shape on the top edge
            Center(
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 16, 15, 79), // Color of the top rectangle
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                        80.0), // Radius for circular shape on top
                  ),
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: ref
                                  .watch(translationProvider.notifier)
                                  .translate("calcul") +
                              '\n',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black, // Shadow color
                                  offset:
                                      Offset(2.0, 2.0), // Shadow offset (x, y)
                                  blurRadius: 4.0,
                                )
                              ]),
                        ),
                        TextSpan(
                            text: ref
                                .watch(translationProvider.notifier)
                                .translate("simulateur"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black, // Shadow color
                                    offset: Offset(
                                        2.0, 2.0), // Shadow offset (x, y)
                                    blurRadius: 4.0,
                                  )
                                ])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 250,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              navigate();
                              // Add your button's onPressed function here
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Color.fromARGB(255, 32, 11,
                                    110) // Add the shadow elevation here
                                ),
                            icon: const Icon(Icons.arrow_right_alt_rounded),
                            label: Text(
                              ref
                                  .watch(translationProvider.notifier)
                                  .translate("start"),
                              style: const TextStyle(
                                  color: Colors
                                      .white, // Set the color of the label text
                                  fontSize: 18,
                                  fontWeight: FontWeight
                                      .bold // Set the font size of the label text
                                  ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ), // White space between the rectangles
            // The bottom rectangle with circular shape on the top edge
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 16, 15, 79), // Color of the bottom rectangle
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        80.0), // Radius for circular shape on top
                  ),
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
