enum DBType {
  integer('INTEGER'),
  text('TEXT'),
  real('REAL');

  final String value;
  const DBType(this.value);

  @override
  String toString() => value;
}
