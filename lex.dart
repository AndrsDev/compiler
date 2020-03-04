import 'dart:io';
import 'dart:core';
import 'dart:collection';
import 'token.dart';
import 'label.dart';
import 'num.dart';
import 'word.dart';


class LexicalAnalyzer {

  HashMap words = HashMap();
  int index = 0;
  int line = 1;
  String char = ' ';
  String digits = "0123456789";
  String letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

  reserve(Word word) {
    words[word.lexeme] = word;
  }

  LexicalAnalyzer() {
    reserve(Word(Label.TRUE, "true"));
    reserve(Word(Label.FALSE, "false"));
  }

  read(String text){
    if(this.index < text.length){
      this.char = text[index];
      index++;
    } else {
      this.char = "#EOF";
    } 
  }

  Token explore(String text) {

    for (int i = index; i < text.length; i++) {
      read(text);
      if(this.char == ' ' || this.char =='\t') continue;
      else if (this.char == '\n') line++;
      else break;
    }

    if(digits.contains(this.char)){
      int v = 0;
      do {
        v = 10 * v + this.char.codeUnitAt(0);
        read(text);
      } while (digits.contains(this.char));

      if (this.char == "#EOF" || this.char == ' '){
        return Num(v);
      } else if (letters.contains(this.char)){
        throw 'Error: Invalid number at line $line. Expected whitespace at pos ${index}';
      }
    }

    if(letters.contains(this.char)){
      String buffer = "";
      do {
        buffer+= this.char;
        read(text);
      } while (letters.contains(this.char) || digits.contains(this.char));

      Word w = words[buffer];
      if(w != null) return w;
      w = Word(Label.ID, buffer);
      words[buffer] = w;
      return w; 
    }

    Token t = Token(this.char.codeUnitAt(0));
    this.char = ' ';
    return t;
  }
}


Future<void> main() async {
  try{
    LexicalAnalyzer analyzer = LexicalAnalyzer();
    String expression = stdin.readLineSync();
    Token token = analyzer.explore(expression);
    print("\n");

    if(token is Num){
      print("A number was found.");
    } else if (token is Word) {
      print("An identifier was found.");
    }
  } catch (e){
    print(e);
  }
}
