import 'package:intl/intl.dart';

class Lugar {

  static const CAMPO_ID        = '_id';
  static const CAMPO_NOME      = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_CATEGORIA = 'categoria';
  static const CAMPO_DATA      = 'data';

  int id;
  String nome;
  String descricao;
  String categoria;
  DateTime? data;
  String? fotoPath;
  String? endereco;

  Lugar({
    required this.id,
    required this.nome,
    required this.descricao,
    this.categoria = 'Geral',
    this.data,
    this.fotoPath,
    this.endereco,
  });

  String get dataFormatada {
    if (data == null) return '';
    return DateFormat('dd/MM/yyyy').format(data!);
  }
}
