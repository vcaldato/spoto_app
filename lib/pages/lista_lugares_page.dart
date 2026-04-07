import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dao/lugar_dao.dart';
import '../model/lugar.dart';
import '../pages/filtro_page.dart';
import '../widgets/conteudo_form_dialog.dart';

class ListaLugaresPage extends StatefulWidget {
  @override
  _ListaLugaresPageState createState() => _ListaLugaresPageState();
}

class _ListaLugaresPageState extends State<ListaLugaresPage> {

  static const ACAO_EDITAR  = 'editar';
  static const ACAO_DELETAR = 'deletar';

  final _lugares = <Lugar>[];
  final _dao     = LugarDao(); // acesso ao banco via DAO

  // Cores
  static const _bg     = Color(0xFFF0EBE4);
  static const _card   = Color(0xFFFAF7F4);
  static const _dark   = Color(0xFF2A2420);
  static const _muted  = Color(0xFF9E9088);
  static const _border = Color(0xFFDDD5C8);
  static const _input  = Color(0xFFE5DFD7);
  static const _tag    = Color(0xFFE5DFD7);
  static const _tagTxt = Color(0xFF7A706A);
  static const _subtle = Color(0xFFBBB0A8);

  // Carrega a lista do banco assim que a tela é montada
  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  Color _corCategoria(String cat) {
    switch (cat) {
      case 'Praia':       return const Color(0xFFDDD5C8);
      case 'Natureza':    return const Color(0xFFC8D5CC);
      case 'Restaurante': return const Color(0xFFD5CCDA);
      case 'Museu':       return const Color(0xFFD5CCDA);
      default:            return _input;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _criarBody(),
      bottomNavigationBar: _criarTabBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        backgroundColor: _dark,
        foregroundColor: _bg,
        elevation: 4,
        tooltip: 'Novo Lugar',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _criarBody() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spoto',
                        style: GoogleFonts.inter(
                            fontSize: 28, fontWeight: FontWeight.w800,
                            color: _dark, letterSpacing: -0.5)),
                    Text(
                      '${_lugares.length} lugar${_lugares.length != 1 ? 'es' : ''} visitado${_lugares.length != 1 ? 's' : ''}',
                      style: GoogleFonts.inter(fontSize: 13, color: _muted),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _abrirFiltro,
                  icon: const Icon(Icons.filter_list, color: _muted),
                ),
              ],
            ),
          ),
          Expanded(child: _criarLista()),
        ],
      ),
    );
  }

  Widget _criarLista() {
    if (_lugares.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 48, color: _subtle),
            const SizedBox(height: 12),
            Text('Nenhum lugar cadastrado.',
                style: GoogleFonts.inter(fontSize: 15, color: _muted)),
            const SizedBox(height: 4),
            Text('Toque em + para adicionar.',
                style: GoogleFonts.inter(fontSize: 13, color: _subtle)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
      itemCount: _lugares.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _criarCard(_lugares[index]),
    );
  }

  Widget _criarCard(Lugar lugar) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => _criarItensMenuPopUp(),
      onSelected: (acao) {
        if (acao == ACAO_EDITAR) {
          _abrirForm(lugarAtual: lugar);
        } else {
          _excluir(lugar);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6, offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 72,
              color: _corCategoria(lugar.categoria),
              alignment: Alignment.center,
              child: Text('FOTO',
                  style: GoogleFonts.inter(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      letterSpacing: 0.5, color: _muted)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 9, 13, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: _tag, borderRadius: BorderRadius.circular(5)),
                    child: Text(lugar.categoria,
                        style: GoogleFonts.inter(
                            fontSize: 10, fontWeight: FontWeight.w600, color: _tagTxt)),
                  ),
                  const SizedBox(height: 5),
                  Text('${lugar.id} — ${lugar.nome}',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
                  if (lugar.descricao.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(lugar.descricao,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 11, color: _muted)),
                  ],
                  if (lugar.data != null) ...[
                    const SizedBox(height: 1),
                    Text(lugar.dataFormatada,
                        style: GoogleFonts.inter(fontSize: 11, color: _subtle)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _criarItensMenuPopUp() {
    return [
      PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(children: [
          const Icon(Icons.edit, color: Colors.black),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Editar', style: GoogleFonts.inter(fontSize: 13))),
        ]),
      ),
      PopupMenuItem<String>(
        value: ACAO_DELETAR,
        child: Row(children: [
          const Icon(Icons.delete, color: Colors.red),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Excluir', style: GoogleFonts.inter(fontSize: 13))),
        ]),
      ),
    ];
  }

  // Confirma antes de excluir — chama o DAO após confirmação
  void _excluir(Lugar lugar) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 10),
          Text('Atenção',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        content: Text('Esse registro será removido definitivamente!',
            style: GoogleFonts.inter(fontSize: 13, color: _muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar',
                style: GoogleFonts.inter(color: _muted, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (lugar.id == null) return;
              // Exclui do banco e atualiza a lista
              _dao.excluir(lugar.id!).then((success) {
                if (success) _atualizarLista();
              });
            },
            child: Text('Excluir',
                style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // Abre o filtro e recarrega a lista se houve alteração
  void _abrirFiltro() {
    Navigator.of(context).pushNamed(FiltroPage.ROUTE_NAME).then((alterou) {
      if (alterou == true) _atualizarLista();
    });
  }

  // Abre o formulário para novo lugar ou edição
  void _abrirForm({Lugar? lugarAtual}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          lugarAtual == null ? 'Novo Lugar' : 'Editar lugar',
          style: GoogleFonts.inter(
              fontSize: 17, fontWeight: FontWeight.w800, color: _dark),
        ),
        content: SingleChildScrollView(
          child: ConteudoFormDialog(key: key, lugarAtual: lugarAtual),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar',
                style: GoogleFonts.inter(color: _muted, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              if (key.currentState != null && key.currentState!.dadosValidados()) {
                final lugar = key.currentState!.novoLugar;
                // Salva no banco (INSERT ou UPDATE) e recarrega a lista
                _dao.salvar(lugar).then((success) {
                  if (success) _atualizarLista();
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Salvar',
                style: GoogleFonts.inter(color: _dark, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _atualizarLista() async {
    final prefs = await SharedPreferences.getInstance();

    final campoOrdenacao      = prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO)  ?? Lugar.CAMPO_ID;
    final usaOrdemDecrescente = prefs.getBool(FiltroPage.USAR_ORDEM_DECRESCENTE)   ?? false;
    final filtroNome          = prefs.getString(FiltroPage.CHAVE_FILTRO_NOME)       ?? '';

    final lugares = await _dao.listar(
      filtro:               filtroNome,
      campoOrdenacao:       campoOrdenacao,
      usarOrdemDecrescente: usaOrdemDecrescente,
    );

    setState(() {
      _lugares.clear();
      _lugares.addAll(lugares);
    });
  }

  Widget _criarTabBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_tabItem(0, 'Lista'), _tabItem(1, 'Mapa')],
      ),
    );
  }

  Widget _tabItem(int index, String label) {
    final ativo = index == 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                    color: ativo ? _dark : _subtle)),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width:  ativo ? 4 : 0,
              height: ativo ? 4 : 0,
              decoration: const BoxDecoration(color: _dark, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}