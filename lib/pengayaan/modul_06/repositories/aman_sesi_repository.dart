import 'dart:convert';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../storage/penyimpanan_aman.dart';
import 'sesi_repository.dart';

/// Sesi disimpan lewat secure storage platform (Keychain / Keystore).
class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul_06_sesi_pengguna';

  final PenyimpananAman penyimpanan;

  AmanSesiRepository({required this.penyimpanan});

  @override
  String get nama => 'Aman';

  @override
  String get keterangan =>
      'Secure storage platform: bertahan; perlindungan mengikuti '
      'platform dan konfigurasi.';

  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final String? mentah = await penyimpanan.baca(kunciSesi);
    if (mentah == null) return null;

    try {
      return uraiSesiJson(mentah);
    } on FormatException {
      await penyimpanan.hapus(kunciSesi); // Data rusak dibuang.
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) =>
      penyimpanan.tulis(kunciSesi, jsonEncode(sesi.toJson()));

  @override
  Future<void> hapus() => penyimpanan.hapus(kunciSesi);

  @override
  Future<bool> adaSesi() async => (await penyimpanan.baca(kunciSesi)) != null;

  @override
  Future<String?> intipMentah() => penyimpanan.bacaMentah(kunciSesi);
  // Adapter tidak menyediakan pembacaan mentah melalui API aplikasi.
}