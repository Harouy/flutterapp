import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:projet/impotTH.dart';
import 'package:projet/impotTSC.dart';
import 'package:projet/providers/language_provider.dart';
import 'impot1.dart';
import 'models/type.dart';

enum impots { impot1, impot2, impot3, impot4 }

class CHOIX extends ConsumerStatefulWidget {
  @override
  ConsumerState<CHOIX> createState() {
    // TODO: implement createState
    return _CHOIXstate();
  }
}

class _CHOIXstate extends ConsumerState<CHOIX> {
  impots slected = impots.impot1;
  final String key = dotenv.env['API_KEY']!;
  late Future<List<type>> _taxTypes;
  type? _selectedTaxType;
  var codeSimulation = "TPI";

  Future<List<type>> fetchTaxTypes() async {
    final url = Uri.parse(dotenv.env['API_URL1']!);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-API-Key':
          key, // Replace 'X-API-Key' with the actual key your backend expects
    };
    final response = await http.get(
      url,
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      return data
          .map((json) => type(
              codeSimulation: json['codeSimulation'],
              libelle: json['libelle'],
              libelleAR: json['libelleAR']))
          .toList();
    } else {
      throw Exception('Failed to load tax types');
    }
  }

  void navigate() {
    switch (codeSimulation) {
      case "TPI":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Impot1()));
        break;
      case "TH":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ImpotTH()));
        break;
      case "TSC":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ImpotTSC()));
        break;
      default:
        // Handle any other cases or errors here
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    _taxTypes = fetchTaxTypes();
  }

  @override
  Widget build(BuildContext context) {
    final translationModel = ref.watch(translationProvider);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 198, 199),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ref.watch(translationProvider.notifier).translate("choice"),
                style: TextStyle(
                  color: Color.fromARGB(255, 16, 15, 79),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<type>>(
                future: _taxTypes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Pas de données disponibles');
                  } else {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<type>(
                            borderRadius: BorderRadius.circular(8),

                            value: _selectedTaxType ??
                                snapshot.data![0], // Set default value
                            items: snapshot.data!.map<DropdownMenuItem<type>>(
                              (type e) {
                                return DropdownMenuItem<type>(
                                  value: e,
                                  child: Text(
                                    translationModel == 'fr'
                                        ? e.libelle
                                        : e.libelleAR,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (type? values) {
                              if (values == null) {
                                return;
                              }
                              setState(() {
                                _selectedTaxType = values;
                                codeSimulation =
                                    _selectedTaxType!.codeSimulation;
                                print(_selectedTaxType?.codeSimulation);
                              });
                            },
                            underline: Container(),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            isExpanded: true,
                            elevation: 5,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 250,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add your button's onPressed function here
                              navigate();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor:
                                  const Color.fromARGB(255, 32, 11, 110),
                            ),
                            icon: const Icon(Icons.arrow_right_alt_rounded),
                            label: Text(
                              ref
                                  .watch(translationProvider.notifier)
                                  .translate("confirm"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
