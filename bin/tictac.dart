
import 'dart:async';
import 'dart:io';

class CommandParser {
  addParser(String subcommand) {}
}

List<String> findCommandsInPath(){
  var paths = Platform.environment['PATH'].split(':');
  var seperator = Platform.pathSeparator;

  var commands = [];

  for (var path in paths){
    var dir = new Directory(path);
    var files = dir.listSync();
    for(final entity in dir.listSync()){
      if(entity is File && entity.name.startsWith('tictac_')) {
          commands.add(entity.name);
      }
    }
  }
  return commands;
}

Map<String, Path> loadAvailableCommands(){
  var completer = new Completer();
  Map<String, Path> commands = {};
  var dir = new File(new Options().script).directorySync();
  for(final entity in dir.listSync()){
    if(entity is File) {
      var path = new Path(entity.name);
      if(path.filename.startsWith('tictac_')){
        var cmd = path.filenameWithoutExtension.replaceAll('tictac_','');
        commands[cmd] = path;
      }
    }
  }
  return commands;
}

void run(Map commands){
  var args = new Options().arguments;

  if(args.isEmpty)
    return; //TODO: show help


  Path command = commands[args[0]];
  if(command == null){
    print('${args[0]} not found');
    return;
  }

  print(command);
  args[0] = command.toString();
  Process.start(new Options().executable, args).then((process) {
    process.stdout
      .transform(new StringDecoder())
      .transform(new LineTransformer())
      .listen((data) => print(data));
    process.stderr
      .transform(new StringDecoder())
      .transform(new LineTransformer())
      .listen((data) => print(data));
  });
}

void main() {
  run(loadAvailableCommands());
}
