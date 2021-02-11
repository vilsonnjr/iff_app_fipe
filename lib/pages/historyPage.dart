import 'package:flutter/material.dart';
import 'package:iff_app/models/consultaFipe_model.dart';
import 'package:iff_app/service/db_helper.dart';
import 'package:iff_app/widgets/loader.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<ConsultaFipeModel>> futureHistory;

  DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    futureHistory = dbHelper.getConsultas();
//    futureHistory = FavoriteDatabaseService.db.getAllFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de consultas'),
      ),
      body: FutureBuilder<List<ConsultaFipeModel>>(
        future: futureHistory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.length);
            if (snapshot.data.length < 1) {
              return NoHistoryWarning();
            } else {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Dismissible(
                            key: Key('$index'),
                            onDismissed: (direction) {
                              dbHelper.delete(snapshot.data[index].id);

//                              FavoriteDatabaseService.db.deleteFavoriteWithId(
//                                  snapshot.data[index].id);
                            },
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text(
                                    snapshot.data[index].Modelo,
                                    key: Key('favorite-$index'),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                      'Marca: ${snapshot.data[index].Marca}'
                                      '\n'
                                      'Ano: ${snapshot.data[index].AnoModelo}'
                                      '\n'
                                      'Mês Referencia: ${snapshot.data[index].MesReferencia}'
                                      '\n'
                                      'Valor: ${snapshot.data[index].Valor}'),
                                )),
                          );
                        }),
                  ),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return NoHistoryWarning();
          }
          return Loading();
        },
      ),
    );
  }

  Widget NoHistoryWarning() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.announcement,
            size: 50,
            color: Colors.yellow[900],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Nenhum histórico encontrado..",
            key: Key('error-message'),
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
