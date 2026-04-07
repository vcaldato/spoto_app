import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/lugar.dart';
import '../widgets/conteudo_form_dialog.dart';

class FiltroPage extends StatefulWidget {
  static const ROUTE_NAME             = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO  = 'campoOrdenacao';
  static const USAR_ORDEM_DECRESCENTE = 'usarOrdemDecrescente';
  static const CHAVE_FILTRO_NOME      = 'filtroNome';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {

  final _camposParaOrdenacao = {
    Lugar.CAMPO_ID:        'Código',
    Lugar.CAMPO_NOME:      'Nome',
    Lugar.CAMPO_CATEGORIA: 'Categoria',
    Lugar.CAMPO_DATA:      'Data',
  };

  final nomeController      = TextEditingController();
  String campoOrdenacao     = Lugar.CAMPO_ID;
  bool usarOrdemDecrescente = false;
  bool alterouValores       = false;

  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _carregarPrefs();
  }

  void _carregarPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      campoOrdenacao      = prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO)  ?? Lugar.CAMPO_ID;
      usarOrdemDecrescente = prefs.getBool(FiltroPage.USAR_ORDEM_DECRESCENTE)  ?? false;
      nomeController.text = prefs.getString(FiltroPage.CHAVE_FILTRO_NOME)      ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _aoVoltar,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: TextButton(
            onPressed: () => _aoVoltar(),
            child: Text('← Voltar',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted)),
          ),
          leadingWidth: 90,
          centerTitle: false,
          title: Text('Filtro e Ordenação',
              style: GoogleFonts.inter(
                  fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.dark)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: () => _aoVoltar(),
                child: Text('Aplicar',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.dark)),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
          children: [

            _secaoTitulo('Ordenar por'),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _camposParaOrdenacao.entries.map((entry) {
                  final ultimo = entry.key == _camposParaOrdenacao.keys.last;
                  return Column(
                    children: [
                      RadioListTile<String>(
                        value:      entry.key,
                        groupValue: campoOrdenacao,
                        onChanged:  _onCampoOrdenacaoChanged,
                        title: Text(entry.value,
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark)),
                        activeColor: AppColors.dark,
                        dense: true,
                      ),
                      if (!ultimo) const Divider(height: 1, color: AppColors.border),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            _secaoTitulo('Opções'),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: CheckboxListTile(
                value:     usarOrdemDecrescente,
                onChanged: _onDecrescenteChanged,
                title: Text('Ordem decrescente',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark)),
                activeColor: AppColors.dark,
                dense: true,
              ),
            ),

            const SizedBox(height: 20),
            _secaoTitulo('Buscar por nome'),
            const SizedBox(height: 8),

            TextField(
              controller: nomeController,
              onChanged:  _onFiltroNomeChanged,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
              decoration: InputDecoration(
                hintText: 'Nome começa com...',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.subtle),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.dark, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              ),
            ),

            const SizedBox(height: 28),

            GestureDetector(
              onTap: () => _aoVoltar(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text('Aplicar filtro',
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: AppColors.background)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secaoTitulo(String texto) => Text(
    texto.toUpperCase(),
    style: GoogleFonts.inter(
        fontSize: 10, fontWeight: FontWeight.w700,
        color: AppColors.muted, letterSpacing: 0.4),
  );

  void _onCampoOrdenacaoChanged(String? valor) {
    prefs.setString(FiltroPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    alterouValores = true;
    setState(() => campoOrdenacao = valor ?? '');
  }

  // Salva a preferência de ordem decrescente
  void _onDecrescenteChanged(bool? valor) {
    prefs.setBool(FiltroPage.USAR_ORDEM_DECRESCENTE, valor == true);
    alterouValores = true;
    setState(() => usarOrdemDecrescente = valor == true);
  }

  void _onFiltroNomeChanged(String? valor) {
    prefs.setString(FiltroPage.CHAVE_FILTRO_NOME, valor ?? '');
    alterouValores = true;
  }

  Future<bool> _aoVoltar() async {
    Navigator.of(context).pop(alterouValores);
    return true;
  }
}