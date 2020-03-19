import 'token.dart';

class Node {
  Token token;
  Node left;
  Node right;
  Node({this.token, this.left, this.right});


  static String inorder(Node node){
    if(node == null){
      return "";
    }
    return  inorder(node.left)  + inorder(node.right) + node.token.value + " ";    
  }

}