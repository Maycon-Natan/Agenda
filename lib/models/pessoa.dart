class Pessoa {
  int id;
  String nome;
  String telefone;
  String imagem;

  Pessoa(this.id, this.nome, this.telefone, this.imagem);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'imagem': imagem
    };
    return map;
  }

  Pessoa.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    telefone = map['telefone'];
    imagem = map['imagem'];
  }

  @override
  String toString() {
    return "Pessoa => (id:$id, nome:$nome, telefone:$telefone)";
  }
}
