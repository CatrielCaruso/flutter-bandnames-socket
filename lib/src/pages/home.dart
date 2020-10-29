import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_name/src/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Héroe del silencio', votes: 3),
    Band(id: '4', name: 'Bon Jovi', votes: 10),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) {
          return _bandTitle(bands[i]);
        },
      ),
    );
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction){
           
           print('directio:$direction');
           print('Id:${band.id}');
           
           //TODO llamar un borrado en el server

        },
        background:Container(
          padding: EdgeInsets.only(left: 10.0),
          child:ListTile(

            title: Text('Deleting',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            leading: Icon(Icons.delete_forever,color: Colors.white,),
          ),
          color: Colors.redAccent,
          ) ,
        child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20.0),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  _addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
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
            );
          });
    }


    showCupertinoDialog(
      
      context: context, 
      builder: (_)=>CupertinoAlertDialog(
         
         title: Text('New band name: '),
         content: CupertinoTextField(

           controller: textController,


         ),

         actions:<Widget>[


           CupertinoDialogAction(
            
            isDefaultAction: true,
             child: Text('ADD'),
             onPressed: ()=>addBandToList(textController.text),
             
            ),
           CupertinoDialogAction(
            
            isDestructiveAction: true,
             child: Text('Exit'),
             onPressed: ()=>Navigator.pop(context),
             
            ),

         ],


      )
      
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {


      this.bands.add(Band(id: DateTime.now().toString(),name:name,votes: 0 ));

      setState(() {
        
      });
    }

    Navigator.pop(context);
  }
}
