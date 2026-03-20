import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '← Voltar',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
          ),
        ),
        leadingWidth: 90,
        centerTitle: false,
        title: Text(
          'Filtro e Ordenação',
          style: GoogleFonts.inter(
            fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.dark,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _aplicar,
              child: Text(
                'Aplicar',
                style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.dark,
                ),
              ),
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
                      value: entry.key,
                      groupValue: campoOrdenacao,
                      onChanged: (valor) => setState(() => campoOrdenacao = valor!),
                      title: Text(
                        entry.value,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
                      ),
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
              value: usarOrdemDecrescente,
              onChanged: (valor) => setState(() => usarOrdemDecrescente = valor!),
              title: Text(
                'Ordem decrescente',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
              ),
              activeColor: AppColors.dark,
              dense: true,
            ),
          ),

          const SizedBox(height: 20),
          _secaoTitulo('Buscar por nome'),
          const SizedBox(height: 8),

          TextField(
            controller: nomeController,
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
            onTap: _aplicar,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Aplicar filtro',
                style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: AppColors.background,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _secaoTitulo(String texto) {
    return Text(
      texto.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10, fontWeight: FontWeight.w700,
        color: AppColors.muted, letterSpacing: 0.4,
      ),
    );
  }

  void _aplicar() {
    Navigator.of(context).pop({
      FiltroPage.CHAVE_CAMPO_ORDENACAO:   campoOrdenacao,
      FiltroPage.USAR_ORDEM_DECRESCENTE:  usarOrdemDecrescente,
      FiltroPage.CHAVE_FILTRO_NOME:       nomeController.text,
    });
  }
}
