import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

/// Sesi disimpan sebagai teks JSON biasa di SharedPreferences.
/// Bertahan setelah restart, tetapi TIDAK terenkripsi.
class PrefsSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul_06_sesi_pengguna';

  final Future<SharedPreferences> _prefs;

  PrefsSesiRepository({Future<SharedPreferences>? prefs})
      : _prefs = prefs ?? SharedPreferences.getInstance();

  @override
  String get nama => 'Preferensi';

  @override
  String get keterangan =>
      'SharedPreferences: bertahan, tetapi tersimpan sebagai teks biasa '
      '(tidak terenkripsi).';

  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final SharedPreferences prefs = await _prefs;
    final String? mentah = prefs.getString(kunciSesi);
    if (mentah == null) return null;

    try {
      return uraiSesiJson(mentah);
    } on FormatException {
      await prefs.remove(kunciSesi); // Data rusak dibuang.
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(kunciSesi, jsonEncode(sesi.toJson()));
  }

  @override
  Future<void> hapus() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey(kunciSesi);
  }

  @override
  Future<String?> intipMentah() async {
    final SharedPreferences prefs = await _prefs;
    // Demonstrasi ini memperlihatkan bahwa adapter preferensi dapat
    // mengembalikan nilai token melalui API biasa.
    return prefs.getString(kunciSesi);
  }
}