/// [Level]s to control logging output.
enum Level {
  all(0),
  trace(1000),
  navigation(1200),
  network(1500),
  debug(2000),
  info(3000),
  warning(4000),
  error(5000),
  fatal(6000),
  off(10000);

  final int value;

  const Level(this.value);
}