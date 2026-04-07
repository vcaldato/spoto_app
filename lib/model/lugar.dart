import 'package:intl/intl.dart';

class Lugar {
  static const NOME_TABELA     = 'lugares';
  static const CAMPO_ID        = '_id';
  static const CAMPO_NOME      = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_CATEGORIA = 'categoria';
  static const CAMPO_DATA      = 'data';
  static const CAMPO_FOTO      = 'foto_path';
  static const CAMPO_ENDERECO  = 'endereco';

  int?     id;
  String   nome;
  String   descricao;
  String   categoria;
  DateTime? data;
  String?  fotoPath;
  String?  endereco;

  Lugar({
    this.id,
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

  // Converte o objeto para Map — usado no INSERT e UPDATE do banco
  Map<String, dynamic> toMap() => {
    CAMPO_ID:        id,
    CAMPO_NOME:      nome,
    CAMPO_DESCRICAO: descricao,
    CAMPO_CATEGORIA: categoria,
    // Data salva no banco no formato ISO (yyyy-MM-dd) para facilitar ordenação
    CAMPO_DATA:      data == null ? null : DateFormat('yyyy-MM-dd').format(data!),
    CAMPO_FOTO:      fotoPath,
    CAMPO_ENDERECO:  endereco,
  };


  factory Lugar.fromMap(Map<String, dynamic> map) => Lugar(
    id:        map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    nome:      map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    categoria: map[CAMPO_CATEGORIA] is String ? map[CAMPO_CATEGORIA] : 'Geral',
    data:      map[CAMPO_DATA] == null
        ? null
        : DateFormat('yyyy-MM-dd').parse(map[CAMPO_DATA]),
    fotoPath:  map[CAMPO_FOTO] as String?,
    endereco:  map[CAMPO_ENDERECO] as String?,
  );
}