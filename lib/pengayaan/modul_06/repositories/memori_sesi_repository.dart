import '../../../modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

/// Sesi hanya hidup di RAM: hilang saat aplikasi ditutup.
class MemoriSesiRepository implements SesiRepository {
  SesiPengguna? _sesi;

  @override
  String get nama => 'Memori';

  @override
  String get keterangan =>
      'Hanya di RAM: hilang saat aplikasi ditutup atau dimuat ulang.';

  @override
  bool get bertahanSetelahRestart => false;

  @override
  Future<SesiPengguna?> baca() async => _sesi;

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    _sesi = sesi;
  }

  @override
  Future<void> hapus() async {
    _sesi = null;
  }

  @override
  Future<bool> adaSesi() async => _sesi != null;

  @override
  Future<String?> intipMentah() async => null; // Tidak ada berkas/penyimpanan.
}