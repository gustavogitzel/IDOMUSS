import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idomuss/components/textFieldOutline.dart';
import 'package:idomuss/components/titulo_cadastro.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastro_nome.dart';
import 'package:idomuss/screens/authenticate/cadastro/cadastroScaffold.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroTelefone extends StatefulWidget {
  Cliente cliente;
  CadastroTelefone({this.cliente});

  @override
  _CadastroTelefoneState createState() => _CadastroTelefoneState();
}

class _CadastroTelefoneState extends State<CadastroTelefone> {
  bool valorValido;
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    valorValido = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CadastroScaffold(
      <Widget>[
        BackButton(),
        TextCadastro('Qual é o seu número de celular?'),
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextFieldOutline(
                prefixIcon: Icons.phone_iphone,
                label: 'Celular',
                hint: '(XX) X XXXX-XXXX',
                keyboardType: TextInputType.number,
                validator: (val) => val.length < 15 ? "Número inválido!" : null,
                onChanged: (val) {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      widget.cliente.numeroCelular =
                          maskFormatter.getUnmaskedText();
                      valorValido = true;
                    } else {
                      valorValido = false;
                    }
                  });
                },
                inputFormatter: [
                  maskFormatter,
                  LengthLimitingTextInputFormatter(16)
                ],
              )),
            ],
          ),
        ),
      ],
      valorValido
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroNome(
                      cliente: widget.cliente,
                    ),
                  ));
            }
          : null,
    );
  }
}
