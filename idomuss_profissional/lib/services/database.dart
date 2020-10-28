import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idomussprofissional/models/cliente.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/models/servicoContrado.dart';
import 'package:idomussprofissional/screens/home/ranking.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference clientes =
      Firestore.instance.collection("clientes");

  final CollectionReference profissionais =
      Firestore.instance.collection("profissionais");
  final CollectionReference servicos =
      Firestore.instance.collection("servicos");

  final CollectionReference servicosContratados =
      Firestore.instance.collection("servicosContratados");

  Future updateUserData(Profissional profissional) async {
    return await profissionais.document(uid).setData({
      "rg": profissional.rg,
      "cpf": profissional.cpf,
      "cnpj": profissional.cnpj,
      "email": profissional.email,
      "vip": profissional.vip,
      "dataNascimento": profissional.dataNascimento,
      "nome": profissional.nome,
      "numero": profissional.numeroCelular,
      "foto": profissional.foto,
      "genero": profissional.genero,
      "descricao": profissional.descricao,
      "location": profissional.location,
      "servico": profissional.nomeServico,
      "nota": -1,
      "servicosPrestados": 0,
      "curtidas": 0,
      "limite": profissional.limite,
      "uid": uid,
      "melhor": Timestamp.fromDate(DateTime(
        2020,
        9,
        7,
      ))
    });
  }

  Stream<List<String>> get ListaServicos {
    return servicos.snapshots().map(_servicosFromSnapshot);
  }

  List<String> _servicosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data["nome"].toString();
    }).toList();
  }

  Stream<QuerySnapshot> get collections {
    return profissionais.snapshots();
  }

  static Stream<String> getIdServico(String nome) {
    Stream<String> id = Firestore.instance
        .collection("servicos")
        .where("nome", isEqualTo: nome)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return doc.data.keys;
      }).toString();
    });
    return id;
  }

  Stream<List<String>> get enderecosFromCliente {
    return Firestore.instance
        .collection("avaliacao")
        .where("uidProfissional", isEqualTo: uid)
        .snapshots()
        .map(_enderecoListFromSnapshot);
  }

  Stream<List<ServicoContratado>> get proximoServico {
    dynamic now = DateTime.now();
    now = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
    var tomorrow = Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));

    return servicosContratados
        .where("uidProfissional", isEqualTo: uid)
        .where("situacao", whereIn: ['Pendente', "A caminho", "Em andamento"])
        .where("data", isGreaterThanOrEqualTo: now)
        .where("data", isLessThanOrEqualTo: tomorrow)
        .orderBy("data")
        .limit(1)
        .snapshots()
        .map((snapshot) {
          return snapshot.documents.map((doc) {
            return ServicoContratado.fromJson(doc.data);
          }).toList();
        });
  }

  Future<bool> get temNotificacao async {
    List<bool> naoVisualizados = await servicosContratados
        .where("uidProfissional", isEqualTo: uid)
        .where("visualizado", isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return doc.data['visualizado'] == true;
      }).toList();
    }).first;

    return Future.value(naoVisualizados.isNotEmpty);
  }

  Stream<List<ServicoContratado>> get servicosPendentes {
    return servicosContratados
        .where("uidProfissional", isEqualTo: uid)
        .where("situacao", isEqualTo: 'Solicitando')
        .orderBy("data")
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return ServicoContratado.fromJson(doc.data);
      }).toList();
    });
  }

  List<String> _enderecoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data["texto"];
    }).toList();
  }

  Future<Profissional> getProfissional() async {
    return await profissionais.document(uid).snapshots().map((doc) {
      Profissional prof = Profissional.fromJson(doc.data);
      prof.uid = doc.documentID;
      return prof;
    }).first;
  }

  Stream<List<Profissional>> ranking(Profissional atual,
      {int distance = 10000, PrimitiveWrapper posicao}) async* {
    List<Profissional> all = await profissionais
        .where("servico", isEqualTo: atual.nomeServico)
        .orderBy("nota", descending: true)
        .snapshots()
        .map(_profissionalListFromSnapshot)
        .first;

    List<Profissional> ret = new List<Profissional>();
    int i = 1;
    for (Profissional profissional in all) {
      double distanceInMeters = await distanceBetween(
          atual.location.latitude,
          atual.location.longitude,
          profissional.location.latitude,
          profissional.location.longitude);
      if (distanceInMeters <= distance) {
        ret.add(profissional);
        if (profissional.uid == atual.uid)
          posicao.value = i;
        else
          i++;
      }
    }

    yield ret.sublist(0, min(ret.length, 10));
  }

  Stream<Profissional> get profissional {
    return profissionais
        .document(uid)
        .snapshots()
        .map(_profissionalFromSnapshot);
  }

  Profissional _profissionalFromSnapshot(DocumentSnapshot snapshot) {
    Profissional prof;
    prof = Profissional.fromJson(snapshot.data);
    prof.uid = snapshot.documentID;
    return prof;
  }

  List<Profissional> _profissionalListFromSnapshot(QuerySnapshot snapshot) {
    List<Profissional> p = snapshot.documents.map((doc) {
      Profissional ret = Profissional.fromJson(doc.data);
      ret.uid = doc.documentID;
      return ret;
    }).toList();

    return p;
  }

  void deleteUserData() async {
    await profissionais.document(uid).delete();
  }

  Stream<Cliente> getCliente(String uid) {
    return clientes.document(uid).snapshots().map((doc) {
      return Cliente.fromJson(doc.data);
    });
  }
}
