import 'dart:io';
import 'dart:core';
import 'dart:collection';
import 'node.dart';
import 'token.dart';
import 'label.dart';
import 'num.dart';
import 'word.dart';


class Compiler {

  HashMap words = HashMap();
  int index = 0;
  int line = 1;
  String text;
  String char = ' ';
  String digits = "0123456789";
  String letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

  reserve(Word word) {
    words[word.lexeme] = word;
  }

  Compiler(String text) {
    this.text = text;
    reserve(Word(Label.TRUE, "true"));
    reserve(Word(Label.FALSE, "false"));
  }

  bool _isEndOfFile(){
    return this.index >= this.text.length;
  }

  _read(){
    if(!_isEndOfFile()){
      this.char = this.text[index];
      index++;
    } else {
      this.char = "#EOF";
    } 
  }

  //Sintax analyzer
  Node execute(Node node){
    if(_isEndOfFile()){
      return node;
    }

    Token token = _explore();
    node.children.add(
      Node(
        value: token,
        children: List(),
      )
    );
    return execute(node);
  }

  //Lexical analyzer
  Token _explore() {

    for (int i = index; i < this.text.length; i++) {
      _read();
      if(this.char == ' ' || this.char =='\t') continue;
      else if (this.char == '\n') line++;
      else break;
    }

    if(digits.contains(this.char)){
      int v = 0;
      do {
        v = 10 * v + this.char.codeUnitAt(0);
        _read();
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
        _read();
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
    File code = File('code.py');
    String content = await code.readAsString();
    Compiler compiler = Compiler(content);
    Node tree = compiler.execute(Node(
      value: null,
      children: List(),
    ));

    print(content);
    print(tree.children.map((node) => node.value));

    print("\n");
  } catch (e){
    print(e);
  }
}
