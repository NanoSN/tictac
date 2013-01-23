import 'dart:io';
import 'package:tic_development/webserver/handlers.dart';
import 'package:tic_development/util.dart';

void runServer(String basePath, int port) {
  var server = new HttpServer();
  var cdHandler = new CommandDispatcherHandler(basePath);
  var webUiHandler = new WebUiHandler(basePath);
  
  server.defaultRequestHandler = new ClientFileHandler(basePath).onRequest;
  server.addRequestHandler((req) => req.path == "/cd", cdHandler.onRequest);
  server.addRequestHandler((req) => req.path == "/" || req.path == '',
      webUiHandler.onRequest);
  
  server.onError = (error) => print(error);
  server.listen('127.0.0.1', 8080);
  print('listening for connections on $port');
}

main() {
  var directory = new Directory.current();
  runServer('${directory.path}', 8080);
}
