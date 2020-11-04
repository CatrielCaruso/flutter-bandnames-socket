import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_name/src/models/band.dart';
import 'package:band_name/src/services/sockets_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Queen', votes: 1),
    // Band(id: '3', name: 'Héroe del silencio', votes: 3),
    // Band(id: '4', name: 'Bon Jovi', votes: 10),
  ];

  @override
  void initState() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);

    socketServices.socket.on('active-bands', _handleActiveBands);

    //print(payload);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);

    socketServices.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketServices>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: (socketServices.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
        elevation: 1.0,
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 1.0, child: Icon(Icons.add_box), onPressed: _addNewBand),
      body: Column(

        children:<Widget> [

        
        _showGraph(context),
        
       

        Expanded(
          child: ListView.builder(
          shrinkWrap: true,  
          itemCount: bands.length,
          itemBuilder: (context, i) {
            return _bandTitle(bands[i]);
          },
      ),
        ),

        ],
      )
    );
  }

  Widget _bandTitle(Band band) {
    final sockeServices = Provider.of<SocketServices>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          //  print('directio:$direction');
          //  print('Id:${band.id}');

          //emitir: delete-band
          //{'id':band.id}
          sockeServices.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 10.0),
        child: ListTile(
          title: Text(
            'Deleting',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
        color: Colors.redAccent,
      ),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(band.name),
          trailing: Text(
            '${band.vote}',
            style: TextStyle(fontSize: 20.0),
          ),
          onTap: () => sockeServices.socket.emit('vote-band', {'id': band.id})
          //setState(() {}),

          ),
    );
  }

  _addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('New band name: '),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('add'),
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text),
            ),
          ],
        ),
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('New band name: '),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('ADD'),
                  onPressed: () => addBandToList(textController.text),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Exit'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final sockeServices = Provider.of<SocketServices>(context, listen: false);

      // Emitir: add-band

      sockeServices.emit('add-band', {'name': name});

      setState(() {});

      //{name:name}

    }

    Navigator.pop(context);
  }



 // Mostrar gráfica

   Widget _showGraph(BuildContext context){

    final size = MediaQuery.of(context).size;  

    Map<String, double> dataMap = new Map();
    // "Flutter": 5,
    // "React": 3,
    // "Xamarin": 2,
    // "Ionic": 2,

    bands.forEach((band) {

          dataMap.putIfAbsent(band.name, () => band.vote.toDouble());

     });

     final List<Color> colorList=[

       Colors.blue[50],
       Colors.blue[200],
       Colors.pink[50],
       Colors.pink[200],
       Colors.yellow[50],
       Colors.yellow[200]

     ];
  

    return dataMap.isNotEmpty ? 
             SingleChildScrollView(
               scrollDirection:Axis.horizontal ,
          child: Container(
        padding: EdgeInsets.all(20.0),
        //width: size.width*0.5,
        height: size.height*0.3,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 2.0,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
          ),
        ),
      ),
    ) : LinearProgressIndicator(); 

   }







}
