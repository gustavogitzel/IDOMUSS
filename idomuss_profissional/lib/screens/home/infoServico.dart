import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:idomussprofissional/components/head_servico.dart';
import 'package:idomussprofissional/helpers/ColorsSys.dart';
import 'package:idomussprofissional/helpers/constantes.dart';
import 'package:idomussprofissional/helpers/loadPage.dart';
import 'package:idomussprofissional/models/cliente.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/screens/home/chat.dart';
import 'package:idomussprofissional/screens/home/home.dart';
import 'package:idomussprofissional/screens/home/orcamento.dart';
import 'package:idomussprofissional/services/database.dart';

class InfoServico extends StatefulWidget {
  ServicoContratado servicoContratado;
  InfoServico(this.servicoContratado);
  @override
  _InfoServicoState createState() => _InfoServicoState();
}

class _InfoServicoState extends State<InfoServico> {
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseService().visualizarServico(widget.servicoContratado.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: StreamBuilder<Cliente>(
            stream: DatabaseService()
                .getCliente(widget.servicoContratado.uidCliente),
            builder: (context, cliente) {
              if (!cliente.hasData) return LoadPage();

              return FutureBuilder<List<Placemark>>(
                  future: placemarkFromCoordinates(
                      widget.servicoContratado.localizacao.latitude,
                      widget.servicoContratado.localizacao.longitude),
                  builder: (context, location) {
                    if (!location.hasData) return LoadPage();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadServico(
                              cliente.data.nome,
                              cliente.data.foto,
                              formatDate(widget.servicoContratado.data),
                              location.data.first.subLocality),
                          Padding(
                            padding: EdgeInsets.all(paddingSmall),
                            child: Container(
                              padding: EdgeInsets.all(paddingSmall),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: shadow,
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: -1,
                                      child: Icon(
                                        Icons.location_on,
                                        color: ColorSys.primary,
                                      )),
                                  Expanded(
                                    child: AutoSizeText(
                                        "${location.data.first.street}"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(paddingSmall),
                            child: Container(
                              padding: EdgeInsets.all(paddingSmall),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: shadow,
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: -1,
                                      child: Icon(
                                        Icons.home,
                                        color: ColorSys.primary,
                                      )),
                                  Expanded(
                                    child: AutoSizeText(
                                        "${widget.servicoContratado.numero}" +
                                            (widget.servicoContratado
                                                        .complemento ==
                                                    null
                                                ? ""
                                                : ", ${widget.servicoContratado.complemento}")),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: Text(
                              "Forneça um orçamento para este serviço!",
                              style: TextStyle(
                                  color: ColorSys.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeRegular),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: Container(
                              child: RaisedButton(
                                padding: EdgeInsets.all(paddingSmall),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: -1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: paddingTiny),
                                          child: Icon(Icons.monetization_on),
                                        )),
                                    Expanded(
                                      child: AutoSizeText(
                                        "Avalie e forneça o orçamento",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AvaliarOrcamento(
                                        widget.servicoContratado);
                                  }));
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(paddingSmall),
                            child: Text(
                              "Precisa de mais informações?",
                              style: TextStyle(
                                  color: ColorSys.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeRegular),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                paddingSmall, 0, paddingSmall, paddingSmall),
                            child: Container(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.white,
                                padding: EdgeInsets.all(paddingSmall),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: -1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: paddingTiny),
                                          child: Icon(
                                            Icons.message,
                                            color: ColorSys.primary,
                                          ),
                                        )),
                                    Expanded(
                                      child: AutoSizeText(
                                        "Entre em contato com ${cliente.data.nome.split(' ')[0]}",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Chat(cliente.data);
                                  }));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }));
  }
}
