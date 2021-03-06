import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ServicoContratado {
  @protected
  GeoPoint _localizacao;

  @protected
  String _uid,
      _uidCliente,
      _uidProfissional,
      _descricao,
      _situacao,
      _complemento,
      _numero;

  @protected
  double _preco;

  @protected
  DateTime _data;

  @protected
  bool _visualizadoCliente, _visualizadoProfissional;

  ServicoContratado.empty() {
    _localizacao = null;
    _situacao = "Solicitando";
    _uid = _uidCliente =
        _uidProfissional = _descricao = _complemento = _numero = "";
    _preco = -1;
    _data = null;
    _visualizadoProfissional = false;
    _visualizadoCliente = false;
  }

  ServicoContratado(
      this._descricao,
      this._preco,
      this._data,
      this._uidCliente,
      this._uidProfissional,
      this._localizacao,
      this._situacao,
      this._complemento,
      this._numero,
      this._visualizadoCliente,
      this._visualizadoProfissional);

  ServicoContratado.fromJson(Map<String, dynamic> json)
      : _descricao = json['descricao'],
        _situacao = json['situacao'],
        _preco = json['preco'],
        _data = DateTime.fromMillisecondsSinceEpoch(
            json['data'].millisecondsSinceEpoch),
        _uidCliente = json['uidCliente'],
        _uidProfissional = json['uidProfissional'],
        _localizacao = json['localizacao'],
        _numero = json['numero'],
        _complemento = json['complemento'],
        _visualizadoProfissional = json['visualizadoProfissional'],
        _visualizadoCliente = json['visualizadoCliente'];

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get situacao => _situacao;

  set situacao(String value) {
    _situacao = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }

  get uidCliente => _uidCliente;

  set uidCliente(value) {
    _uidCliente = value;
  }

  get uidProfissional => _uidProfissional;

  set uidProfissional(value) {
    _uidProfissional = value;
  }

  double get preco => _preco;

  set preco(double value) {
    _preco = value;
  }

  get data => _data;

  set data(dynamic value) {
    if (value.runtimeType == DateTime)
      _data = value;
    else if (value.runtimeType == Timestamp)
      _data = DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch);
  }

  GeoPoint get localizacao => _localizacao;

  set localizacao(GeoPoint localizacao) {
    _localizacao = localizacao;
  }

  get numero => _numero;

  set numero(value) {
    _numero = value;
  }

  get complemento => _complemento;

  set complemento(value) {
    _complemento = value;
  }

  get visualizadoCliente => _visualizadoCliente;

  set visualizado(value) {
    _visualizadoCliente = value;
  }

  get visualizadoProfissional => _visualizadoProfissional;

  set visualizadoProfissional(value) {
    _visualizadoProfissional = value;
  }
}
