import 'token.dart';

class Word extends Token {
  final String lexeme;
  Word(int label, String value, this.lexeme) : super(label, value);
}