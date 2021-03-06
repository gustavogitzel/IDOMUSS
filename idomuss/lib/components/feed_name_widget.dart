import 'package:flutter/material.dart';
import 'package:idomuss/components/feed_name.dart';
import 'package:idomuss/helpers/ColorsSys.dart';
import 'package:idomuss/helpers/constantes.dart';

class FeedNameWidget extends StatelessWidget {
  String nome;

  FeedNameWidget(this.nome);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorSys.primary,
      elevation: 3.0,
      shape: FeedNameShapeBorder(),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 24.0, left: 20.0, right: 16.0, bottom: 5.0),
        child: Text(
          nome.contains(" ") ? nome.substring(0, nome.indexOf(" ")) : nome,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSizeRegular),
        ),
      ),
    );
  }
}
