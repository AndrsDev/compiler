class Node<T> {
  T value;
  List<Node<T>> children;
  Node({this.value, this.children});
}