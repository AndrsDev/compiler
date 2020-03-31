import 'dart:io';
import 'dart:core';
import 'dart:collection';
import 'utils/node.dart';
import 'utils/token.dart';
import 'utils/label.dart';
import 'utils/num.dart';
import 'utils/word.dart';


class Compiler {

  HashMap words = HashMap();
  int index = 0;
  int line = 1;
  String text;
  String char = ' ';


  String simbols = "-+*/^=";
  String digits = "0123456789";
  String letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

  reserve(Word word) {
    words[word.lexeme] = word;
  }

  Compiler(String text) {
    this.text = text;
    reserve(Word(Label.TRUE, "true", "true"));
    reserve(Word(Label.FALSE, "false", "false"));
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

  void insert(Node node, Token token){
    if(node.right == null){
      if(simbols.contains(token.value)){
        node.left = Node(token: node.token);
        node.token = token;
      } else{
        node.right = Node(token: token);
      }
    } else {
      insert(node.right, token);
    }

  }

  //Sintax analyzer
  Node execute(){

    //Get the first initial token
    Token token = _explore();
    Node tree = Node(token: token);

    //Create the tree with the rest of tokens.
    while(!_isEndOfFile()){
      Token token = _explore();
      insert(tree, token);
    }

    return tree;
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
      int n = 0;
      String v = "";
      do {
        v += this.char;
        n = 10 * n + this.char.codeUnitAt(0);
        _read();
      } while (digits.contains(this.char));

      if (this.char == "#EOF" || this.char == ' '){
        return Num(v, n);
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
      w = Word(Label.ID, buffer, buffer);
      words[buffer] = w;
      return w; 
    }

    Token t = Token(this.char.codeUnitAt(0), this.char);
    this.char = ' ';
    return t;
  }
}





Future<void> main() async {
  try{
    File file = File('code.py');
    String code = await file.readAsString();
    Compiler compiler = Compiler(code);
    Node tree = compiler.execute();
    print(code + "\n");
    print("Tree: ${Node.inorder(tree)}");

    print("\n");
  } catch (e){
    print(e);
  }
}
