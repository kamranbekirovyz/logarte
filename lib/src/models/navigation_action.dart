enum NavigationAction {
  push,
  pop,
  remove,
  replace;

  @override
  String toString() {
    return name.toUpperCase();
  }
}
