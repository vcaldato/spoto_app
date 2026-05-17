import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../model/lugar.dart';
import '../widgets/conteudo_form_dialog.dart';

class MapaPage extends StatefulWidget {
  final List<Lugar> lugares;
  const MapaPage({Key? key, required this.lugares}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  List<Lugar> get _lugaresComLocalizacao =>
      widget.lugares.where((l) => l.temLocalizacao).toList();

  @override
  Widget build(BuildContext context) {
    final centro = _lugaresComLocalizacao.isNotEmpty
        ? LatLng(
      _lugaresComLocalizacao
          .map((l) => l.latitude!)
          .reduce((a, b) => a + b) /
          _lugaresComLocalizacao.length,
      _lugaresComLocalizacao
          .map((l) => l.longitude!)
          .reduce((a, b) => a + b) /
          _lugaresComLocalizacao.length,
    )
        : const LatLng(-15.7801, -47.9292);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mapa',
                    style: GoogleFonts.inter(
                        fontSize: 28, fontWeight: FontWeight.w800,
                        color: AppColors.dark, letterSpacing: -0.5)),
                Text(
                  _lugaresComLocalizacao.isEmpty
                      ? 'Nenhum lugar com localização'
                      : '${_lugaresComLocalizacao.length} lugar${_lugaresComLocalizacao.length != 1 ? 'es' : ''} no mapa',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
                ),
              ],
            ),
          ),

          Expanded(
            child: _lugaresComLocalizacao.isEmpty
                ? _criarEstadoVazio()
                : FlutterMap(
              options: MapOptions(
                initialCenter: centro,
                initialZoom: _lugaresComLocalizacao.length == 1 ? 14 : 5,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.spoto',
                ),
                MarkerLayer(
                  markers: _lugaresComLocalizacao.map((lugar) {
                    return Marker(
                      point: LatLng(lugar.latitude!, lugar.longitude!),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _abrirDetalhe(lugar),
                        child: const Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Color(0xFF2A2420),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _criarEstadoVazio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.map_outlined, size: 48, color: AppColors.subtle),
          const SizedBox(height: 12),
          Text('Nenhum lugar com localização.',
              style: GoogleFonts.inter(fontSize: 15, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text('Use o GPS ao cadastrar um lugar.',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.subtle)),
        ],
      ),
    );
  }

  void _abrirDetalhe(Lugar lugar) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Alça
                Center(
                  child: Container(
                    width: 36, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Foto — toque abre em tela cheia
                if (lugar.fotoPath != null) ...[
                  GestureDetector(
                    onTap: () => _abrirFotoTelaCheia(lugar.fotoPath!),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(lugar.fotoPath!),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.input,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(lugar.categoria,
                      style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: AppColors.tagText)),
                ),
                const SizedBox(height: 8),

                // Nome
                Text('${lugar.id} — ${lugar.nome}',
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w800,
                        color: AppColors.dark, letterSpacing: -0.3)),

                if (lugar.descricao.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(lugar.descricao,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: AppColors.muted, height: 1.5)),
                ],

                if (lugar.data != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: AppColors.subtle),
                      const SizedBox(width: 6),
                      Text(lugar.dataFormatada,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.subtle)),
                    ],
                  ),
                ],

                if (lugar.endereco != null && lugar.endereco!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.subtle),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(lugar.endereco!,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AppColors.subtle)),
                      ),
                    ],
                  ),
                ],

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _abrirFotoTelaCheia(String fotoPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(
                  File(fotoPath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}