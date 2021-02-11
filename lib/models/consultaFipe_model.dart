class ConsultaFipeModel {

  int id;
  String Modelo;
  String Marca;
  int AnoModelo;
  String Combustivel;
  String MesReferencia;
  String CodigoFipe;
  String Valor;

  ConsultaFipeModel(this.id, this.Modelo, this.Marca, this.AnoModelo,
      this.Combustivel, this.MesReferencia, this.CodigoFipe, this.Valor);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'Modelo': Modelo,
      'Marca': Marca,
      'AnoModelo': AnoModelo,
      'Combustivel': Combustivel,
      'MesReferencia': MesReferencia,
      'CodigoFipe': CodigoFipe,
      'Valor': Valor,
    };
    return map;
  }

  ConsultaFipeModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    Modelo = map['Modelo'];
    Marca = map['Marca'];
    AnoModelo = map['AnoModelo'];
    Combustivel = map['Combustivel'];
    MesReferencia = map['MesReferencia'];
    CodigoFipe = map['CodigoFipe'];
    Valor = map['Valor'];
  }
}