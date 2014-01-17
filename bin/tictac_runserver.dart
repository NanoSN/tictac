import 'dart:io';
import 'package:tic_development/webserver/handlers.dart';
import 'package:tic_development/util.dart';

void runServer(String basePath, int port) {
  //  var server = new HttpServer();
  //  var cdHandler = new CommandDispatcherHandler(basePath);
  var webUiHandler = new WebUiHandler(basePath);
  /*
  server.defaultRequestHandler = new ClientFileHandler(basePath).onRequest;
  server.addRequestHandler((req) => req.path == "/cd", cdHandler.onRequest);
  server.addRequestHandler((req) => req.path == "/" || req.path == '',
      webUiHandler.onRequest);
  
  server.onError = (error) => print(error);
  server.listen('127.0.0.1', 8080);
  */

  HttpServer.bind('127.0.0.1', port)
    .then((server){
      server.listen((req){
        if(req.uri.path == "/" || req.uri.path == '') {
          webUiHandler.onRequest(req, req.response);
        } else {
          new ClientFileHandler(basePath).onRequest(req, req.response);
        }
      });
    });
  print('listening for connections on $port');
}

void serveStaticFiles(String basePath, int port) {
  HttpServer.bind('127.0.0.1', port)
    .then((server){
      server.listen((req){
        new ClientFileHandler(basePath).onRequest(req, req.response);
      });
      print('listening for connections on $port');
    });
}
main() {
  var directory = Directory.current;
  serveStaticFiles('${directory.path}', 8000);
}
