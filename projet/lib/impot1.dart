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
import 'package:projet/providers/language_provider.dart';

class Impot1 extends ConsumerStatefulWidget {
  @override
  ConsumerState<Impot1> createState() {
    // TODO: implement createState
    return _Impot1();
  }
}

class _Impot1 extends ConsumerState<Impot1> {
  BannerAd? bannerAd;
  var isloading = false;
  double parixaqu = 0;
  double prix_cession = 0;
  var annee_aquisition = 0;
  var codeSimulation = "TPI";
  double montantInteret = 0;
  double depenseInvistesement = 0;
  final String key = dotenv.env['API_KEY']!;
  @override
  void initState() {
    super.initState();
    didChangeDependencies();
    /* createad();*/ // Load the interstitial ad when the widget initializes
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

      print(prix_cession);
      print(annee_aquisition);
      print(parixaqu);
      Calculrequest calculrequest = new Calculrequest(
          annee_aquisition,
          prix_cession,
          parixaqu,
          depenseInvistesement,
          montantInteret,
          codeSimulation);

      final url = Uri.parse(dotenv.env['API_URL2']!);
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
            'prixacquis': calculrequest.prix_aquisition.toString(),
            'prixcession': calculrequest.prix_cession.toString(),
            'anneacquisition': calculrequest.annee_aquisition.toString(),
            'depenseInvistesement':
                calculrequest.depenseInvistesement.toString(),
            'montantInteret': calculrequest.montantInteret.toString(),
            'codeSimulation': calculrequest.codeSimulation.toString()
          }), // Convert the 'Calculrequest' object to JSON format
        );
        if (response.statusCode == 200) {
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
              ref.watch(translationProvider.notifier).translate("impot1"),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Column(children: [
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
                              fontSize: 20),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 132, 15,
                                        183)), // Change the underline color when focused
                              ),
                              label: Text(
                                ref
                                        .watch(translationProvider.notifier)
                                        .translate("priceaqu") +
                                    ":",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 16, 15, 79),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplire  ce champ';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            parixaqu = double.parse(value!);
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 15,
                                      183)), // Change the underline color when focused
                            ),
                            label: Text(
                                ref
                                        .watch(translationProvider.notifier)
                                        .translate("depense") +
                                    "(facultatif):",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 16, 15, 79),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ),
                          onSaved: (value) {
                            depenseInvistesement =
                                value!.isEmpty ? 0 : double.parse(value);
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 15,
                                      183)), // Change the underline color when focused
                            ),
                            label: Text(
                                ref
                                        .watch(translationProvider.notifier)
                                        .translate("montant") +
                                    "(facultatif):",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 16, 15, 79),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ),
                          onSaved: (value) {
                            montantInteret =
                                value!.isEmpty ? 0 : double.parse(value);
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          maxLength: 4,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 15,
                                      183)), // Change the underline color when focused
                            ),
                            label: Text(
                                ref
                                        .watch(translationProvider.notifier)
                                        .translate("année") +
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
                            annee_aquisition = int.parse(value!);
                          },
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 132, 15,
                                          183)), // Change the underline color when focused
                                ),
                                label: Text(
                                    ref
                                            .watch(translationProvider.notifier)
                                            .translate("prix") +
                                        ":",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 16, 15, 79),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplire  ce champ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              prix_cession = double.parse(value!);
                            }),
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
                                  backgroundColor: const Color.fromARGB(255, 32,
                                      11, 110) // Add the shadow elevation here
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
        ]),
      ),
    );
  }
}
