import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iff_app/pages/historyPage.dart';

import 'models/consultaFipe_model.dart';
import 'service/db_helper.dart';
import 'models/fipeModel.dart';

void main() => runApp(FipeApp());

class FipeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fipe App',
      debugShowCheckedModeBanner: false,
      home: FipeAppHome(),
    );
  }
}

class FipeAppHome extends StatefulWidget {
  @override
  _FipeAppHomeState createState() => _FipeAppHomeState();
}

class _FipeAppHomeState extends State<FipeAppHome> {

  DBHelper dbHelper;

  @override
  void initState() {
    _getMarcasList();

    dbHelper = DBHelper();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Consulta tabela FIPE"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HistoryPage(),
                  ));
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(bottom: 10, top: 0),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _idMarca,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Selecione uma Marca'),
                        onChanged: (String newValue) {
                          setState(() {
                            _idMarca = newValue;
                            _changeMarca();
                            _getVeiculosList();
                          });
                        },
                        items: marcasList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['nome']),
                            value: item['codigo'].toString(),
                          );
                        })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _idVeiculo,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Selecione um Veiculo'),
                        onChanged: (String newValue) {
                          setState(() {
                            _idVeiculo = newValue;
                            _changeVeiculo();
                            _getModelosList();
                          });
                        },
                        items: veiculosList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['nome']),
                            value: item['codigo'].toString(),
                          );
                        })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _idModelo,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Selecione um Modelo'),
                        onChanged: (String newValue) {
                          setState(() {
                            _idModelo = newValue;
                            _getFipe();
                          });
                        },
                        items: modelosList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['nome']),
                            value: item['codigo'].toString(),
                          );
                        })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 0),
            color: Colors.white,
            child: Visibility(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  labelResultado('Modelo', fipe == null ? '' : fipe.Modelo),
                  labelResultado('Marca', fipe == null ? '' : fipe.Marca),
                  labelResultado(
                      'Ano', fipe == null ? '' : fipe.AnoModelo.toString()),
                  labelResultado(
                      'Combustivel', fipe == null ? '' : fipe.Combustivel),
                  labelResultado(
                      'Mês Referência', fipe == null ? '' : fipe.MesReferencia),
                  labelResultado(
                      'Código Fipe', fipe == null ? '' : fipe.CodigoFipe),
                  labelResultado('Valor', fipe == null ? '' : fipe.Valor),
                ],
              ),
              visible: mostrarResultado,
            ),
          ),
        ],
      ),
    );
  }

  Column labelResultado(String nome, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            nome,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            valor ?? '',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }

  bool mostrarResultado = false;
  Fipe fipe;

  List marcasList;
  String _idMarca;

  String marcasUrl = 'https://parallelum.com.br/fipe/api/v1/carros/marcas';

  Future<String> _getMarcasList() async {
    await http.get(marcasUrl).then((response) {
      var data = json.decode(response.body);

      setState(() {
        marcasList = data;
      });
    });
  }

  List veiculosList;
  String _idVeiculo;

  Future<String> _getVeiculosList() async {
    await http.get(_getVeiculosAPIUrl(_idMarca)).then((response) {
      var data = json.decode(response.body);

      setState(() {
        veiculosList = data['modelos'];
      });
    });
  }

  String _getVeiculosAPIUrl(String idMarca) {
    return 'https://parallelum.com.br/fipe/api/v1/carros/marcas/' +
        idMarca +
        '/modelos';
  }

  List modelosList;
  String _idModelo;

  Future<String> _getModelosList() async {
    await http.get(_getModelosAPIUrl(_idMarca, _idVeiculo)).then((response) {
      var data = json.decode(response.body);

      setState(() {
        modelosList = data;
      });
    });
  }

  String _getModelosAPIUrl(String idMarca, String idVeiculo) {
    return 'https://parallelum.com.br/fipe/api/v1/carros/marcas/' +
        idMarca +
        '/modelos/' +
        idVeiculo +
        '/anos';
  }

  Future<String> _getFipe() async {
    await http
        .get(_getFipeAPIUrl(_idMarca, _idVeiculo, _idModelo))
        .then((response) {
      var data = json.decode(response.body);

      setState(() {
        fipe = Fipe.fromJson(data);
        mostrarResultado = true;
        addConsultHistory(fipe);
      });
    });
  }

  String _getFipeAPIUrl(String idMarca, String idVeiculo, String idModelo) {
    return 'https://parallelum.com.br/fipe/api/v1/carros/marcas/' +
        idMarca +
        '/modelos/' +
        idVeiculo +
        '/anos/' +
        idModelo;
  }

  void _changeVeiculo() {
    modelosList = null;
    _idModelo = null;
    mostrarResultado = false;
  }

  void _changeMarca() {
    veiculosList = null;
    _idVeiculo = null;
    _changeVeiculo();
  }

  void addConsultHistory(Fipe fipe) {
    ConsultaFipeModel novaConsulta = new ConsultaFipeModel(
        null,
        fipe.Modelo,
        fipe.Marca,
        fipe.AnoModelo,
        fipe.Combustivel,
        fipe.MesReferencia,
        fipe.CodigoFipe,
        fipe.Valor);

    dbHelper.add(novaConsulta);


  }


}

