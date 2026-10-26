import 'package:flutter/material.dart';

import '../repositories/sesi_repository.dart';

/// Papan kecil untuk membandingkan perilaku tiap tempat penyimpanan.
class PapanDiagnostikPenyimpanan extends StatefulWidget {
  final SesiRepository repository;

  const PapanDiagnostikPenyimpanan({super.key, required this.repository});

  @override
  State<PapanDiagnostikPenyimpanan> createState() =>
      _PapanDiagnostikPenyimpananState();
}

class _PapanDiagnostikPenyimpananState
    extends State<PapanDiagnostikPenyimpanan> {
  bool _sedangMengintip = false;
  bool _sudahMengintip = false;
  String? _hasilIntip;

  @override
  void didUpdateWidget(covariant PapanDiagnostikPenyimpanan oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ganti penyimpanan → hasil intipan lama tidak berlaku lagi.
    if (!identical(oldWidget.repository, widget.repository)) {
      _sedangMengintip = false;
      _sudahMengintip = false;
      _hasilIntip = null;
    }
  }

  Future<void> _intip() async {
    setState(() => _sedangMengintip = true);
    final String? hasil = await widget.repository.intipMentah();
    if (!mounted) return;
    setState(() {
      _hasilIntip = hasil;
      _sudahMengintip = true;
      _sedangMengintip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SesiRepository repo = widget.repository;
    final TextTheme teks = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Diagnostik penyimpanan', style: teks.titleMedium),
            const SizedBox(height: 8),
            Text('Penyimpanan: ${repo.nama}'),
            Text(
              'Bertahan setelah restart: '
              '${repo.bertahanSetelahRestart ? 'Ya' : 'Tidak'}',
            ),
            const SizedBox(height: 4),
            Text(repo.keterangan, style: teks.bodySmall),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _sedangMengintip ? null : _intip,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Intip nilai mentah'),
            ),
            if (_sedangMengintip) ...<Widget>[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (_sudahMengintip && !_sedangMengintip) ...<Widget>[
              const SizedBox(height: 12),
              if (_hasilIntip == null)
                Text(
                  'Tidak ada nilai mentah yang dapat dibaca melalui API.',
                  style: teks.bodySmall,
                )
              else
                SelectableText(
                  _hasilIntip!,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
            ],
          ],
        ),
      ),
    );
  }
}