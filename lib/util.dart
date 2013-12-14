import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

var PREFIX = 'tictac_';
var PROJECT_MARKER_FILE = 'pubspec.yaml';

Map<String, String> findTictacCommands(Directory dir){
  if(!dir.existsSync()) return {};
  var commands = {};
  var paths = dir.listSync()
    .where((_) => p.basename(_.path).startsWith(PREFIX))
    .map((_) => _.path);

  for(final path in paths){
    var cmd = p.basenameWithoutExtension(path).replaceAll(PREFIX,'');
    commands[cmd] = path;
  }
  return commands;
}

Directory findProjectDirectory(){
  var dir = Directory.current;
  var project = dir.listSync().where((_) =>
      p.basename(_.path) == PROJECT_MARKER_FILE);
  while(project.isEmpty)
  {
    if(dir.path == dir.parent.path)
      throw 'Not in a Dart project.';
    dir = dir.parent;
    project = dir.listSync().where((_) =>
        p.basename(_.path) == PROJECT_MARKER_FILE);
  }
  return dir;
}

List<String> findTestFiles(){
  var dir = new Directory(p.join(findProjectDirectory().path, 'test'));
  return dir.listSync(recursive:true, followLinks:false)
    .where((_) => p.basename(_.path).endsWith('_test.dart'))
    .map((_) => _.path).toList();
}

Future<int> startProcess(args){
  return Process.start(Platform.executable, args).then((process) {
    process.stdout
      .transform(new Utf8Decoder())
      .transform(new LineSplitter())
      .listen((data) => print(data));
    process.stderr
      .transform(new Utf8Decoder())
      .transform(new LineSplitter())
      .listen((data) => print(data));
    return process.exitCode;
  });
}
