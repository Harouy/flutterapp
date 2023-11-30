import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet/providers/language_provider.dart';

import 'choix.dart';

class LastPage extends ConsumerStatefulWidget {
  LastPage({required this.data});
  final dynamic data;

  @override
  ConsumerState<LastPage> createState() => _LastPageState();
}

class _LastPageState extends ConsumerState<LastPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 198, 199),
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 16, 15, 79)),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ref.watch(translationProvider.notifier).translate("votre"),
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 16, 15, 79)),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.data['impotSimultion'].toString() + "DH",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 16, 15, 79)),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            ref.watch(translationProvider.notifier).translate("traduction"),
            style: TextStyle(color: Color.fromARGB(255, 16, 15, 79)),
          )
        ],
      )),
    );
  }
}
