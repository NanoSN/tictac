
import 'dart:async';
import 'dart:io';

class CommandParser {
  addParser(String subcommand) {}
}

void findCommandsInPath(){
  var paths = Platform.environment['PATH'].split(':');
  var seperator = Platform.pathSeparator;

  var commands = [];

  for (var path in paths){
    var dir = new Directory(path);
    var lister = dir.list();
    lister.onFile = (file) {
      var filename = new Path(file).filename;
      if(filename.startsWith('tictac_')){
        commands.add(filename);
      }
    };
    lister.onDone = (done) => print('done $commands');
  }
}


Future<Map> loadAvailableCommands(){
  var completer = new Completer();
  Map<String, Path> commands = {};
  var dir = new File(new Options().script).directorySync();
  var lister = dir.list();
  lister.onFile = (file) {
    var path = new Path(file);
    if(path.filename.startsWith('tictac_')){
      var cmd = path.filenameWithoutExtension.replaceAll('tictac_','');
      commands[cmd] = path;
    }
  };
  lister.onDone = (done) => completer.complete(commands);
  return completer.future;
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
    var stdoutStream = new StringInputStream(process.stdout);
    stdoutStream.onLine = () => print(stdoutStream.readLine());
    var stderrStream = new StringInputStream(process.stderr);
    stderrStream.onLine = () => print(stderrStream.readLine());    
    //process.stderr.onData = process.stderr.read;
    process.onExit = (exitCode) {
      print('exit code: $exitCode');
    };
  });  
}

void main() {
  loadAvailableCommands().then(run);
}
