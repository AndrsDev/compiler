import 'label.dart';
import 'token.dart';

class Num extends Token {
  final int number;

  Num(String value, this.number, ) : super(Label.NUM, value);
}