import 'dart:io';
import 'add.dart';

void update(File wordsToAdd){
File dictionary = new File('C:\\Users\\lukal\\AppData\\Roaming\\Microsoft\\Spelling\\sr-Latn-ME\\default.dic');
var txt = wordsToAdd.readAsStringSync();

dictionary.deleteSync();//deleting default.dic which contains the dictionary


var i = 0;
var k = 0;
//while loop gets individual word from a file and adds them to the dictionary
while(i<txt.length){
   k = i;
  while(i<txt.length-1 && txt[i]!=' '){
    i++;
  }
  
  add(txt.substring(k,i+1));
  
  i++;
  
}
}


void main(List<String> args) {

File wordToAdd = new File('C:\\Users\\lukal\\AppData\\Roaming\\Microsoft\\Spelling\\sr-Latn-ME\\moje_rijeci.txt');
update(wordToAdd);
}