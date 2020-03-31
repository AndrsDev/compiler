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
    return  inorder(node.left) + node.token.value + " " + inorder(node.right);
  }

  static String preorder(Node node){
    if(node == null){
      return "";
    }
    return node.token.value + " " + preorder(node.left) + preorder(node.right);    
  }

  static String postorder(Node node){
    if(node == null){
      return "";
    }
    return postorder(node.left) + postorder(node.right) + node.token.value + " " ;    
  }

  void herarchy(String prefix){
    String formattedPrefix = " ";

    for (var i = 1; i < prefix.length / 2; i++) {
      formattedPrefix += " ";
    }

    if(prefix.isNotEmpty) formattedPrefix += prefix[prefix.length - 2];

    print('$formattedPrefix${this.token.value}');

    if(this.left != null) left.herarchy(prefix + "├╴");
    if(this.right != null) right.herarchy(prefix + "└╴");
  }
}