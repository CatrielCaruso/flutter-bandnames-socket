
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_name/src/services/sockets_services.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketServices=Provider.of<SocketServices>(context);
    
    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children:<Widget>[

            Text('ServerSatus:${socketServices.serverStatus}')

          ],
        )
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: (){

         //Tarea
         socketServices.emit('emitir-mensaje',{ 
           
           'nombre':'Flutter', 
           'mensaje':'Hola desde flutter'
          
        });
         //emitir: {nombre: 'Flutter'; mensaje:'Hola desde flutter';}
         
       }
       
      ),
   );
  }
}