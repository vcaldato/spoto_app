import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/lugar.dart';

// Cores centralizadas
class AppColors {
  static const background = Color(0xFFF0EBE4);
  static const card       = Color(0xFFFAF7F4);
  static const dark       = Color(0xFF2A2420);
  static const muted      = Color(0xFF9E9088);
  static const border     = Color(0xFFDDD5C8);
  static const input      = Color(0xFFE5DFD7);
  static const tagText    = Color(0xFF7A706A);
  static const subtle     = Color(0xFFBBB0A8);
  static const success    = Color(0xFF3A7A3A);
  static const successBg  = Color(0xFFEEF5EE);
}

class ConteudoFormDialog extends StatefulWidget {
  final Lugar? lugarAtual;

  ConteudoFormDialog({Key? key, this.lugarAtual}) : super(key: key);

  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey            = GlobalKey<FormState>();
  final nomeController     = TextEditingController();
  final descController     = TextEditingController();
  final dataController     = TextEditingController();
  final enderecoController = TextEditingController();
  final dataFormat         = DateFormat('dd/MM/yyyy');

  String _categoriaSelecionada = 'Geral';
  bool   _fotoSelecionada      = false; // TODO: image_picker
  bool   _gpsObtido            = false; // TODO: geolocator

  final _categorias = [
    'Geral', 'Restaurante', 'Natureza', 'Praia',
    'Turismo', 'Cidade', 'Museu', 'Hotel',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.lugarAtual != null) {
      nomeController.text      = widget.lugarAtual!.nome;
      descController.text      = widget.lugarAtual!.descricao;
      dataController.text      = widget.lugarAtual!.dataFormatada;
      enderecoController.text  = widget.lugarAtual!.endereco ?? '';
      _categoriaSelecionada    = widget.lugarAtual!.categoria;
      _fotoSelecionada         = widget.lugarAtual!.fotoPath != null;
    }
  }

  Widget _label(String texto) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 4),
    child: Text(
      texto.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10, fontWeight: FontWeight.w700,
        color: AppColors.muted, letterSpacing: 0.4,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint, {Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.subtle),
      filled: true,
      fillColor: AppColors.card,
      prefixIcon: prefix,
      suffixIcon: suffix,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── FOTO ──────────────────────────────────────────
          _label('Foto'),
          GestureDetector(
            onTap: _selecionarFoto,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: _fotoSelecionada ? AppColors.input : AppColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _fotoSelecionada ? AppColors.dark : AppColors.border,
                  width: _fotoSelecionada ? 1.5 : 1,
                ),
              ),
              child: _fotoSelecionada
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 18, color: AppColors.dark),
                        const SizedBox(width: 8),
                        Text(
                          'Foto selecionada',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(() => _fotoSelecionada = false),
                          child: const Icon(Icons.close,
                              size: 16, color: AppColors.muted),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt_outlined,
                            size: 24, color: AppColors.muted),
                        const SizedBox(height: 4),
                        Text(
                          'Câmera ou galeria',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.muted),
                        ),
                        // TODO: image_picker
                      ],
                    ),
            ),
          ),

          // ── NOME ──────────────────────────────────────────
          _label('Nome'),
          TextFormField(
            controller: nomeController,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
            decoration: _inputDecoration('Nome do lugar'),
            validator: (valor) {
              if (valor == null || valor.isEmpty) return 'Informe o nome';
              return null;
            },
          ),

          // ── DESCRIÇÃO ─────────────────────────────────────
          _label('Descrição'),
          TextFormField(
            controller: descController,
            maxLines: 2,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
            decoration: _inputDecoration('Como foi a visita?'),
          ),

          // ── CATEGORIA ─────────────────────────────────────
          _label('Categoria'),
          DropdownButtonFormField<String>(
            value: _categoriaSelecionada,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
            decoration: _inputDecoration(''),
            items: _categorias.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (valor) => setState(() => _categoriaSelecionada = valor!),
          ),

          // ── DATA ──────────────────────────────────────────
          _label('Data da visita'),
          TextFormField(
            controller: dataController,
            readOnly: true,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
            decoration: _inputDecoration(
              'Selecione a data',
              prefix: IconButton(
                onPressed: _mostrarCalendario,
                icon: const Icon(Icons.calendar_today,
                    size: 18, color: AppColors.muted),
              ),
              suffix: IconButton(
                onPressed: () => dataController.clear(),
                icon: const Icon(Icons.close, size: 16, color: AppColors.muted),
              ),
            ),
          ),

          // ── LOCALIZAÇÃO ───────────────────────────────────
          _label('Localização'),
          TextFormField(
            controller: enderecoController,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.dark),
            decoration: _inputDecoration(
              'Buscar endereço...',
              prefix: const Icon(Icons.search,
                  size: 18, color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 8),

          // Botão GPS
          GestureDetector(
            onTap: _obterGps,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.my_location,
                      size: 16, color: AppColors.muted),
                  const SizedBox(width: 10),
                  Text(
                    'Usar minha localização (GPS)',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark),
                  ),
                  // TODO: geolocator
                ],
              ),
            ),
          ),

          // Confirmação GPS
          if (_gpsObtido) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC5DDC5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 15, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    'Localização obtida com sucesso',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.success),
                  ),
                ],
              ),
            ),
          ],

        ],
      ),
    );
  }

  void _selecionarFoto() {
    // TODO: image_picker — câmera ou galeria
    setState(() => _fotoSelecionada = true);
  }

  void _obterGps() {
    // TODO: geolocator — obter lat/lng e geocoding reverso
    setState(() {
      _gpsObtido = true;
      enderecoController.text = 'Localização obtida via GPS';
    });
  }

  void _mostrarCalendario() {
    final texto = dataController.text;
    var data = DateTime.now();
    if (texto.isNotEmpty) data = dataFormat.parse(texto);
    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((dataSelecionada) {
      if (dataSelecionada != null) {
        setState(() =>
            dataController.text = dataFormat.format(dataSelecionada));
      }
    });
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  Lugar get novoLugar => Lugar(
        id: widget.lugarAtual?.id ?? 0,
        nome: nomeController.text,
        descricao: descController.text,
        categoria: _categoriaSelecionada,
        data: dataController.text.isEmpty
            ? null
            : dataFormat.parse(dataController.text),
        endereco: enderecoController.text.isEmpty
            ? null
            : enderecoController.text,
        fotoPath: _fotoSelecionada ? 'placeholder' : null,
      );
}
