import 'dart:async';
import 'package:tictac/util.dart';

main(){
  var exitCodes = [];
  var files = findTestFiles();
  for(final test in files){
    exitCodes.add(startProcess([test]));
  }
  Future.wait(exitCodes).then((codes){
    for(int i=0; i< codes.length; i++){
      if(codes[i] != 0){
        print('Error running ${files[i]}. Exit code: ${codes[i]}');
      }
    }
  });
}
