/// initializes new project in current directory or in the specified directory

/*
  /pubspec.yaml
  /lib/
  /test/
  /tools/
 */

import 'dart:io';

void verify_directory_is_empty({String path: '.'}){
  var files = new Directory(path).listSync();
  if(!files.isEmpty) throw new Exception('this path: "$path" is not empty');
}

void create_pubspec_yaml_file({String path: '.'}){
  var content = """
name:  new_project
description: new project description

dependencies:
  logging: any
  unittest: any
  tic:
    path: /Users/sam/Development/Projects/tic/
""";

  var file = new File('$path/pubspec.yaml');
  var sink = file.openWrite();
  sink
    ..write(content)
    ..close();
}

void create_directories(List<String> directories, {path: '.'}){
  for(final dir in directories)
    new Directory('$path/$dir').createSync(recursive: true);
}

main() {
  verify_directory_is_empty();
  create_pubspec_yaml_file();
  create_directories(['lib', 'test', 'tools']);
}
