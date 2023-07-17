class Ujumbe {
  String kutoka;
  String kwenda;
  String ujumbe;
  DateTime muda;

  Ujumbe(
      {required this.kutoka,
      required this.kwenda,
      required this.ujumbe,
      required this.muda});

  Map<String, dynamic> kuwaUjumbe() => {
        'kutoka': kutoka,
        'kwenda': kwenda,
        'ujumbe': ujumbe,
        'muda': muda.toIso8601String()
      };
}
