import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projet/ad_state.dart';
import 'package:projet/lastpage.dart';
import 'package:projet/models/calculrequest.dart';
import 'package:projet/models/impotTSCcalcul.dart';
import 'package:projet/providers/language_provider.dart';

class ImpotTSC extends ConsumerStatefulWidget {
  @override
  ConsumerState<ImpotTSC> createState() {
    // TODO: implement createState
    return _ImpotTSC();
  }
}

class _ImpotTSC extends ConsumerState<ImpotTSC> {
  BannerAd? bannerAd;
  var isloading = false;

  var codeSimulation = "TSC";
  double valeuLocatAnuu = 0;
  String typeHibation = "P";
  String zoneHibation = "CU";

  final String key = dotenv.env['API_KEY']!;
  @override
  void initState() {
    super.initState();
    // Load the interstitial ad when the widget initializes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adStateProvider = Provider<AdState>((ref) {
      // Create and return your AdState instance here.
      return AdState();
    });
    setState(() {
      bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: "ca-app-pub-6568047370472354/9039217423",
          listener: BannerAdListener(
            onAdLoaded: (ad) => print('Ad loaded'),
            onAdClosed: (ad) => print('Ad closed'),
          ),
          request: AdRequest())
        ..load();
    });
  }

  void save() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      setState(() {
        isloading = true;
      });

      impotTSCclcul calculrequest = new impotTSCclcul(
          valeuLocatAnuu, typeHibation, zoneHibation, codeSimulation);

      final url = Uri.parse(dotenv.env['API_URL4']!);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'X-API-Key':
            key, // Replace 'X-API-Key' with the actual key your backend expects
      };
      try {
        final response = await http.post(
          url,
          headers: headers,
          body: json.encode({
            'valeuLocatAnuu': calculrequest.valeuLocatAnuu.toString(),
            'typeHibation': calculrequest.typeHibation.toString(),
            'zoneHibation': calculrequest.zoneHibation.toString(),
            'codeSimulation': calculrequest.codeSimulation.toString()
          }), // Convert the 'Calculrequest' object to JSON format
        );
        if (response.statusCode == 200) {
          print(response.body);
          // Request successful, handle the response data
          setState(() {
            isloading = false;
          });
          Map<String, dynamic> responseData = jsonDecode(response.body);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LastPage(data: responseData)));
          // Assuming your response data is a JSON object with key-value pairs
          // Access the values using responseData['key_name']
          print('Response: ${responseData}');
        } else {
          // Request failed, handle the error
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        // Error occurred while making the request
        print('Error: $e');
      }
    }
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> options = [
      ref.watch(translationProvider.notifier).translate("p"),
      ref.watch(translationProvider.notifier).translate("s")
    ];
    String optiondef = options[0];
    List<String> options2 = [
      ref.watch(translationProvider.notifier).translate("CU"),
      ref.watch(translationProvider.notifier).translate("CD"),
      ref.watch(translationProvider.notifier).translate("SE"),
      ref.watch(translationProvider.notifier).translate("ZP")
    ];
    String optiondef2 = options2[0];
    // TODO: implement build
    if (isloading) {
      return Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor:
                Colors.white, // Change this to your desired cursor color
          ),
        ),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 196, 198, 199),
          appBar: AppBar(backgroundColor: Color.fromARGB(255, 16, 15, 79)),
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white, // Change this to your desired cursor color
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 196, 198, 199),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 16, 15, 79),
          title: Text(
              ref.watch(translationProvider.notifier).translate("impottsc"),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 132, 15,
                                        183)), // Change the underline color when focused
                              ),
                              label: Text(
                                  ref
                                          .watch(translationProvider.notifier)
                                          .translate("valeuLocatAnuu") +
                                      ":",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 16, 15, 79),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplire  ce champ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              valeuLocatAnuu = double.parse(value!);
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: optiondef,
                            onChanged: (newValue) {
                              setState(() {
                                optiondef = newValue!;
                                if (optiondef == "Principale" ||
                                    optiondef == "رئيسي") {
                                  typeHibation = "P";
                                } else {
                                  typeHibation = "S";
                                }
                              });
                            },
                            items: options
                                .map<DropdownMenuItem<String>>((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: ref
                                      .watch(translationProvider.notifier)
                                      .translate("typeh") +
                                  ":",
                              labelStyle: TextStyle(
                                color: Color.fromARGB(
                                    255, 16, 15, 79), // Text color for label
                                fontWeight: FontWeight.bold,
                                fontSize: 20, // Font size for label
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 15, 183),
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Font size
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: optiondef2,
                            onChanged: (newValue) {
                              setState(() {
                                optiondef2 = newValue!;
                                switch (optiondef2) {
                                  case 'communes urbaines':
                                  case ' المجتمعات الحضرية ':
                                    zoneHibation = 'CU';
                                  case 'centre délimité':
                                  case 'مركز محدد':
                                    zoneHibation = 'CD';
                                  case 'station estival hivernal thermal':
                                  case "المنتجع الحراري الصيفي الشتوي":
                                    zoneHibation = 'SE';
                                  case "zones périphériques":
                                  case "المناطق الطرفية":
                                    zoneHibation = "ZP";
                                    break;
                                }
                              });
                            },
                            items: options2
                                .map<DropdownMenuItem<String>>((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: ref
                                      .watch(translationProvider.notifier)
                                      .translate("zone") +
                                  ":",
                              labelStyle: TextStyle(
                                color: Color.fromARGB(
                                    255, 16, 15, 79), // Text color for label
                                fontWeight: FontWeight.bold,
                                fontSize: 20, // Font size for label
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 15, 183),
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Font size
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _formkey.currentState!.reset();
                                },
                                child: Text('Renitialiser',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: save,
                                child: Text('Calculer'),
                                style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: const Color.fromARGB(
                                        255,
                                        32,
                                        11,
                                        110) // Add the shadow elevation here
                                    ),
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ),
            if (bannerAd != null)
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: AdWidget(
                    ad: bannerAd!,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
