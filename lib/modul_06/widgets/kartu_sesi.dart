import 'package:flutter/material.dart';

import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback? onKeluar;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;
    final bool habis = sesi.sudahKedaluwarsa(sekarang);
    final Duration sisa = sesi.sisaWaktu(sekarang);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 32,
                backgroundColor: warna.primaryContainer,
                child: Text(
                  _inisial(sesi.nama),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: warna.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              sesi.nama,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Center(
              child: Chip(
                avatar: const Icon(Icons.badge_outlined, size: 18),
                label: Text(SesiPengguna.labelPeran(sesi.peran)),
              ),
            ),
            const Divider(height: 28),
            _Baris(
              ikon: Icons.email_outlined,
              label: 'Email',
              nilai: sesi.email,
            ),
            _Baris(
              ikon: Icons.login_rounded,
              label: 'Masuk pada',
              nilai: _formatWaktu(sesi.masukPada),
            ),
            _Baris(
              ikon: Icons.event_busy_outlined,
              label: 'Berlaku sampai',
              nilai: _formatWaktu(sesi.kedaluwarsaPada),
            ),
            _Baris(
              ikon: Icons.timer_outlined,
              label: 'Sisa waktu',
              nilai: habis ? 'Sesi berakhir' : _formatSisa(sisa),
            ),
            _Baris(
              ikon: Icons.key_outlined,
              label: 'Token',
              nilai: _samarkanToken(sesi.token),
            ),
            if (onKeluar != null) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: onKeluar,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _inisial(String nama) {
    final String bersih = nama.trim();
    return bersih.isEmpty ? '?' : bersih[0].toUpperCase();
  }


  static String _samarkanToken(String token) {
    if (token.length <= 8) return '••••';
    return '${token.substring(0, 8)}••••';
  }

  static String _formatWaktu(String iso) {
    final DateTime? t = DateTime.tryParse(iso);
    if (t == null) return '-';
    String dua(int n) => n.toString().padLeft(2, '0');
    return '${dua(t.day)}-${dua(t.month)}-${t.year} ${dua(t.hour)}:${dua(t.minute)}';
  }

  static String _formatSisa(Duration d) {
    if (d == Duration.zero) return 'Berakhir';
    final int jam = d.inHours;
    final int menit = d.inMinutes.remainder(60);
    final int detik = d.inSeconds.remainder(60);
    if (jam > 0) return '$jam jam $menit menit';
    if (menit > 0) return '$menit menit $detik detik';
    return '$detik detik';
  }
}

class _Baris extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;

  const _Baris({
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(ikon, size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              nilai,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}