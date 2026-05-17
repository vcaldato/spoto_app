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
  static const CAMPO_LATITUDE  = 'latitude';
  static const CAMPO_LONGITUDE = 'longitude';

  int?      id;
  String    nome;
  String    descricao;
  String    categoria;
  DateTime? data;
  String?   fotoPath;
  String?   endereco;
  double?   latitude;
  double?   longitude;

  Lugar({
    this.id,
    required this.nome,
    required this.descricao,
    this.categoria = 'Geral',
    this.data,
    this.fotoPath,
    this.endereco,
    this.latitude,
    this.longitude,
  });


  bool get temLocalizacao => latitude != null && longitude != null;

  String get dataFormatada {
    if (data == null) return '';
    return DateFormat('dd/MM/yyyy').format(data!);
  }

  Map<String, dynamic> toMap() => {
    CAMPO_ID:        id,
    CAMPO_NOME:      nome,
    CAMPO_DESCRICAO: descricao,
    CAMPO_CATEGORIA: categoria,
    CAMPO_DATA:      data == null ? null : DateFormat('yyyy-MM-dd').format(data!),
    CAMPO_FOTO:      fotoPath,
    CAMPO_ENDERECO:  endereco,
    CAMPO_LATITUDE:  latitude,
    CAMPO_LONGITUDE: longitude,
  };

  factory Lugar.fromMap(Map<String, dynamic> map) => Lugar(
    id:        map[CAMPO_ID] as int?,
    nome:      map[CAMPO_NOME] as String? ?? '',
    descricao: map[CAMPO_DESCRICAO] as String? ?? '',
    categoria: map[CAMPO_CATEGORIA] as String? ?? 'Geral',
    data:      map[CAMPO_DATA] == null
        ? null
        : DateFormat('yyyy-MM-dd').parse(map[CAMPO_DATA]),
    fotoPath:  map[CAMPO_FOTO] as String?,
    endereco:  map[CAMPO_ENDERECO] as String?,
    latitude:  map[CAMPO_LATITUDE] as double?,
    longitude: map[CAMPO_LONGITUDE] as double?,
  );
}