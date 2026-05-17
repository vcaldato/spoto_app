import '../database/database_provider.dart';
import '../model/lugar.dart';

class LugarDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Lugar lugar) async {
    final db     = await dbProvider.database;
    final valores = lugar.toMap();

    if (lugar.id == null) {
      lugar.id = await db.insert(Lugar.NOME_TABELA, valores);
      return true;
    } else {
      final rows = await db.update(
        Lugar.NOME_TABELA,
        valores,
        where:     '${Lugar.CAMPO_ID} = ?',
        whereArgs: [lugar.id],
      );
      return rows > 0;
    }
  }

  Future<bool> excluir(int id) async {
    final db = await dbProvider.database;
    final rows = await db.delete(
      Lugar.NOME_TABELA,
      where:     '${Lugar.CAMPO_ID} = ?',
      whereArgs: [id],
    );
    return rows > 0;
  }

  Future<List<Lugar>> listar({
    String filtro               = '',
    String campoOrdenacao       = Lugar.CAMPO_ID,
    bool   usarOrdemDecrescente = false,
  }) async {
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${Lugar.CAMPO_NOME}) LIKE '${filtro.toUpperCase()}%'";
    }

    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) orderBy += ' DESC';

    final db        = await dbProvider.database;
    final resultado = await db.query(
      Lugar.NOME_TABELA,
      where:   where,
      orderBy: orderBy,
    );

    return resultado.map((m) => Lugar.fromMap(m)).toList();
  }
}