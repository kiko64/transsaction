import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:transaccion/utils/globals.dart' as globals;
import 'package:transaccion/data/transactiox.dart';
import 'package:transaccion/pages/login_page.dart';
import 'package:transaccion/pages/transaction_form.dart';
import 'package:transaccion/services/database_handler_transaction.dart';
import 'package:transaccion/pages/action_page.dart';

String _queryText = '';
int criterio = 0;
int _page = 0;
//late Record control;

class TransactionPage extends StatefulWidget {
  @override
  TransactionPage({Key? key, required this.title}) : super(key: key);
  final String title;

  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late SearchBar searchBar;
  late DatabaseHandlerTransaction handler;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Color(0xff6A9438),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title + ' - ${globals.instance}'),
        centerTitle: true,
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    _refrescar(value.toString());

    setState(() {
      var context = _scaffoldKey.currentContext;
      if (context == null) {
        return;
      }
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          new SnackBar(content: new Text('You wrote "$value"!')));
    });
  }

  _TransactionPageState() {
    searchBar = new SearchBar(
      hintText: 'Buscar...',
      inBar: true,

      buildDefaultAppBar: buildAppBar,
      setState: setState,
//      onSubmitted: onSubmitted, // Este sirve cuando termina de escribir
      onChanged: onSubmitted,

//        onCleared: () {print("************************* Search bar has been cleared");},
//        onClosed: () {print("************************* Search bar has been closed");}
    );
  }

  @override
  void initState() {
    _cargar();
    super.initState();
    this.handler = DatabaseHandlerTransaction();

    this.handler.initializeDB().whenComplete(() async {
//      await this.handler.addTransaction();
      setState(() {});
    });
  }

  _cargar() async {
//    control = await getRegistroByRegistro('70002 and tabla = 700') as Record;
//    print(control.descripcion.toString());
  }

  void _refrescar(String query) {
    _queryText = query;
    setState(() {
      this.handler = DatabaseHandlerTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetMenuLateral = Drawer(
      child: ListView(
        children: <Widget>[
          Text(
            '',
            textScaleFactor: 1.8,
          ),
          Text(
            '     OcoboSoft',
            textScaleFactor: 2.2,
          ),
          Text(
            '         Versión 1.05',
            textScaleFactor: 1.4,
          ),
          Padding(
            child: Image.asset("assets/images/icon.png"),
            padding: EdgeInsets.all(84.0),
          ),
          Text(
            '',
            textScaleFactor: 1.2,
          ),
          Text(
            '         Base de datos: ${globals.instance}',
            textScaleFactor: 1.4,
          ),
          Text(
            '         Usuario: ${globals.user}',
            textScaleFactor: 1.4,
          ),
          new ListTile(
            title: Text(
              'Autenticación',
              textScaleFactor: 1.5,
            ),
            leading: Icon(
              Icons.login_outlined,
              size: 26.0,
              color: Colors.black,
            ),
            onTap: () async {
              var route = MaterialPageRoute(
                builder: (BuildContext context) =>
                    LoginPage('Autenticación'), // Llamar la forma de auxiliares
//                builder: (BuildContext context) => MyCustomForm(), // Llamar la forma de auxiliares
              );
              await Navigator.of(context).push(route);
              _queryText = '';
              print('transaction_page _queryText - ${_queryText}');
              _refrescar(_queryText);
            },
          ),
          new ListTile(
            title: Text(
              "Acciones",
              textScaleFactor: 1.5,
            ),
            leading: Icon(
              Icons.pending_actions,
              size: 26.0,
              color: Colors.black,
            ),
            onTap: () async {
              var route = MaterialPageRoute(
                builder: (BuildContext context) => AccionesPage(
                    'Acciones'), // Llamar la forma de auxiliares AccionesPage(control: control,)
              );
              await Navigator.of(context).push(route);
              _refrescar(_queryText);
            },
          ),
          new ListTile(
            title: Text(
              "Configuración",
              textScaleFactor: 1.5,
            ),
            leading: Icon(
              Icons.settings_outlined,
              size: 26.0,
              color: Colors.black,
            ),
            onTap: () async {},
          ),
        ],
      ),
    );

    Widget widgetCurvedNavigationBar = CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _page,

      height: 52,
      color: Color(0xff6A9438),
      buttonBackgroundColor: Color(0xff6A9438), //Colors.grey[400],
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeOutCubic,

      animationDuration: Duration(milliseconds: 900),
      letIndexChange: (index) => true,

      items: <Widget>[
        Icon(
          Icons.format_list_bulleted_rounded,
          size: 28,
          color: Colors.white,
        ), // color: Colors.white, // ACTUALIZAR
        Icon(
          Icons.create_outlined,
          size: 28,
          color: Colors.white,
        ), // color: Colors.white, // ACTUALIZAR
        Icon(
          Icons.alarm_on_outlined,
          size: 28,
          color: Colors.white,
        ),
        Icon(
          Icons.data_usage_outlined,
          size: 28,
          color: Colors.white,
        ),
        Icon(
          Icons.check_circle_outline,
          size: 28,
          color: Colors.white,
        ),
        Icon(
          Icons.cancel_outlined,
          size: 28,
          color: Colors.white,
        ),
      ],

      onTap: (index) {
        _page = index;
        switch (index) {
          case 0:
            criterio = 0;
            break;
          case 1:
            criterio = 12601;
            break;
          case 2:
            criterio = 12602;
            break;
          case 3:
            criterio = 12603;
            break;
          case 4:
            criterio = 12604;
            break;
          case 5:
            criterio = 12605;
            break;
          default:
            criterio = 0;
            break;
        }
        _refrescar(_queryText);
//            cubit.getAll(
//                query: state.lastSearch,
//                status: codeSelectFilter(index),
//                clean: true);
      },
    );

    Widget widgetFloatingActionButton = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
//                height:46,
          child: FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.add),
              backgroundColor: Color(0xff6A9438),
              onPressed: () async {
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('yyyy-MM-dd');
                final String formatted = formatter.format(now);

                Transactiox actual = Transactiox(
                    ejecutar: 0,
//                          fecha: DateTime.now(),
                    fecha: formatted.toString(),
                    usuario: globals.user,
                    seguimiento: 12601,
                    agenda: 0,
                    documento: 0,
                    cuenta: 0,
                    valor: 10000,
                    observacion: 'Prueba',
                    registro: '',
                    mascara: 1,
                    archivo0: '',
                    archivo1: '',
                    archivo2: '',
                    archivo3: '',
                    desAgenda: '',
                    parAgenda0: '0',
                    parAgenda1: '0',
                    parAgenda2: '0',
                    parAgenda3: '1',
                    desMascara: '',
                    desDocumento: '',
                    desCuenta: '',
                    desSeguimiento: 'Preparación');

                var route = MaterialPageRoute(
                  builder: (BuildContext context) => TransactionWidget(actual,
                      'Adicionar transacción'), // Llamar la forma de toma de lectura
                );
                await Navigator.of(context).push(route);
                _refrescar(_queryText);
//                      _refrescar('');
              }),
        ),
      ],
    );

    return Scaffold(
      appBar: searchBar.build(context),
      body: FutureBuilder(
        future: this
            .handler
            .retrieveTransactions(_queryText, criterio), // kiko MySql
        builder:
            (BuildContext context, AsyncSnapshot<List<Transactiox>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
              itemCount: snapshot.data
                  ?.length, // snapshot.data?.length = soccerPlayers.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.delete_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  key: ValueKey<int>(snapshot.data![index].ejecutar!),
                  onDismissed: (DismissDirection direction) async {
                    if (snapshot.data![index].seguimiento == 12601) {
                      var newData = {
                        "ejecutar": snapshot.data![index].ejecutar.toString(),
                        "observacion": snapshot.data![index].observacion
                                .toString()
                                .trim() +
                            " Actividad cancelada",
                        "seguimiento": 12605
                      };
                      print('transaction_page newData - ${newData}');
                      await this.handler.updateUsingHelper(newData); // kiko
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Error, actividad no permitida',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.red.withOpacity(0.68),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      elevation: 1.0,
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.fromLTRB(8, 0, 8, 0), // L, U, R, D
                        title: Text(
                            snapshot.data![index].ejecutar.toString() +
                                '- ' +
                                snapshot.data![index].desAgenda.toString() +
                                ' (' +
                                snapshot.data![index].desSeguimiento
                                    .toString() +
                                ')',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),

                        subtitle: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: snapshot.data![index].desDocumento
                                          .toString()
                                          .trim() +
                                      ', ' +
                                      snapshot.data![index].fecha
                                          .toString()
                                          .trim(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              TextSpan(
//                                    text: ' ( \$ ' + NumberFormat.currency(locale: 'eu', symbol: '').format(snapshot.data![index].valor) + ')',
                                  text: ' ' +
                                      NumberFormat.currency(
                                              locale: 'eu', symbol: '')
                                          .format(snapshot.data![index].valor),
                                  style: int.parse(snapshot
                                              .data![index].parAgenda0
                                              .toString()) <
                                          33008
                                      ? TextStyle(
                                          color: Color(0xff6A9438),
                                          fontSize: 18)
                                      : TextStyle(
                                          color: Colors.red, fontSize: 18)),
                            ],
                          ),
                        ),

//                          subtitle: Text(
//                              snapshot.data![index].desDocumento.toString() + '' +
//                              snapshot.data![index].fecha.toString().trim() +
//                              ' ( \$ ' + NumberFormat.currency(locale: 'eu', symbol: '').format(snapshot.data![index].valor) + ')'
//                          ),
//                          trailing: Icon(
//                          int.parse(snapshot.data![index].parAgenda0.toString()) == 33008
//                                ? Icons.thumb_down // panorama_fish_eye, Icons.loop
//                                : Icons.thumb_up,
//                            color: int.parse(snapshot.data![index].parAgenda2.toString()) == 33008
//                                ? Colors.red
//                                : Colors.teal,
//                          ),
                        onTap: () async {
                          List<String> imgList = [];
                          var route = MaterialPageRoute(
                            builder: (BuildContext context) => TransactionWidget(
                                snapshot.data![index],
                                'Transacción No.' +
                                    snapshot.data![index].ejecutar
                                        .toString()), // Llamar la forma de toma de lectura
                          );
                          await Navigator.of(context).push(route);
                          _refrescar(_queryText);
                        },
                      )),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      bottomNavigationBar: widgetCurvedNavigationBar,
      drawer: widgetMenuLateral,
      floatingActionButton: widgetFloatingActionButton,
    );
  }
}

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          Text(
            '',
            textScaleFactor: 1.8,
          ),
          Text(
            'OcoboSoft',
            textScaleFactor: 1.8,
          ),
          Text(
            'Versión 1.05',
            textScaleFactor: 1.2,
          ),
          Padding(
            child: Image.asset("assets/images/icon.png"),
            padding: EdgeInsets.all(84.0),
          ),
          Text(
            '',
            textScaleFactor: 1.2,
          ),
          Text(
            '                 Base de datos: ${globals.instance}',
            textScaleFactor: 1.2,
          ),
          Text(
            '                 Usuario: ${globals.user}',
            textScaleFactor: 1.2,
          ),
          new ListTile(
            title: Text(
              'Autenticación',
            ),
            leading: Icon(
              Icons.login_outlined,
              size: 26.0,
              color: Colors.black,
            ),
            onTap: () async {
              var route = MaterialPageRoute(
                builder: (BuildContext context) =>
                    LoginPage('Autenticación'), // Llamar la forma de auxiliares
//                builder: (BuildContext context) => MyCustomForm(), // Llamar la forma de auxiliares
              );
              await Navigator.of(context).push(route);
              _queryText = '';
              print('transaction_page _queryText - ${_queryText}');
            },
          ),
          new ListTile(
            title: Text(
              "Acciones",
            ),
            leading: Icon(
              Icons.pending_actions,
              size: 26.0,
              color: Colors.black,
            ),
            onTap: () async {
              var route = MaterialPageRoute(
                builder: (BuildContext context) => AccionesPage(
                    'Acciones'), // Llamar la forma de auxiliares AccionesPage(control: control,)
              );
              await Navigator.of(context).push(route);
              _queryText = '';
            },
          ),
          new ListTile(
            title: Text(
              "Configuración",
            ),
            leading: Icon(
              Icons.settings_outlined,
              size: 26.0,
              color: Colors.black,
            ),
            onTap: () async {},
          ),
        ],
      ),
    );
  }
}
