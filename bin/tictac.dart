import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:tictac/util.dart';
import 'package:path/path.dart' as p;

class CommandParser {
  addParser(String subcommand) {}
}

Map<String, String> findInPathCommands(){
  var paths = Platform.environment['PATH'].split(':');
  var dirs = paths.map((_) => new Directory(_)).where((_) => _.exists());
  var commands = {};
  for (final dir in dirs){
    commands.addAll(findTictacCommands(dir));
  }
  return commands;
}

Map<String, String> findDefaultCommands(){
  var dir = new File(Platform.script.path).parent;
  return findTictacCommands(dir);
}

Map<String, String> findProjectCommands(){
  var dir = new Directory(p.join(findProjectDirectory().path, 'tool'));
  return findTictacCommands(dir);
}

void run(List args, Map commands){
  if(args.isEmpty) {
    print('Available commands: ${commands.keys.join(' ')}');
    return;
  }

  String command = commands[args[0]];
  if(command == null){
    print('${args[0]} not found');
    return;
  }

  print(command);
  args[0] = command.toString();
  Process.start(Platform.executable, args).then((process) {
    process.stdout
      .transform(new Utf8Decoder())
      .transform(new LineSplitter())
      .listen((data) => print(data));
    process.stderr
      .transform(new Utf8Decoder())
      .transform(new LineSplitter())
      .listen((data) => print(data));
  });
}

void main(List args) {
  var commands = {};
  commands.addAll(findDefaultCommands());
  commands.addAll(findInPathCommands());

  try {
    commands.addAll(findProjectCommands());
  } catch (e) {}

  run(args, commands);
}
