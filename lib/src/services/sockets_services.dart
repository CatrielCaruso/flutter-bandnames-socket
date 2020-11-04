import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketServices with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket =>this._socket;

  Function get emit => this._socket.emit;

  SocketServices() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    this. _socket = IO.io('http://10.0.2.2:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {

    //   print('nuevo-mensaje: ');
    //   print('nombre:'+ payload['nombre']);
    //   print('mensaje:'+ payload['mensaje']);
    //   print(payload.containsKey('mensaje2')?payload['mensaje2']:'no hay');

    // });
      
      //socket.off('nuevo-mensaje');

  }
}
