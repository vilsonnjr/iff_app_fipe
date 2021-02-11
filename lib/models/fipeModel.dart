class Fipe {
  final String Modelo;
  final String Marca;
  final int AnoModelo;
  final String Combustivel;
  final String MesReferencia;
  final String CodigoFipe;
  final String Valor;

  Fipe(this.Modelo, this.Marca, this.AnoModelo, this.Combustivel,
      this.MesReferencia, this.CodigoFipe, this.Valor);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "Modelo": Modelo,
      "Marca": Marca,
      "AnoModelo": AnoModelo,
      "Combustivel": Combustivel,
      "MesReferencia": MesReferencia,
      "CodigoFipe": CodigoFipe,
      "Valor": Valor,
    };
  }

  Fipe.fromJson(Map<String, dynamic> json)
      : Modelo = json['Modelo'],
        Marca = json['Marca'],
        AnoModelo = json['AnoModelo'],
        Combustivel = json['Combustivel'],
        MesReferencia = json['MesReferencia'],
        CodigoFipe = json['CodigoFipe'],
        Valor = json['Valor'];
}