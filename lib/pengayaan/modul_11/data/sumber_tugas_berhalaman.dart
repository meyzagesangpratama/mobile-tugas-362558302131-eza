import 'dart:async';

enum StatusTugas { aktif, selesai }

class TugasPerforma {
  final int nomor;
  final String mataKuliah;
  final StatusTugas status;

  TugasPerforma({required this.nomor, required this.mataKuliah, required this.status});

  String get judul => 'Tugas praktikum ${nomor.toString().padLeft(4, '0')}';
}

class SumberTugasBerhalaman {
  static const int totalTugasDiServer = 1000;
  static const int ukuranHalaman = 20;

  static Future<List<TugasPerforma>> ambilHalaman(int halaman) async {
    // Perbaikan: Delay dipercepat jadi 100ms agar unit test tidak lama
    await Future.delayed(const Duration(milliseconds: 100));

    int mulai = (halaman - 1) * ukuranHalaman;

    // Perbaikan: Cek nilai `mulai`, bukan `halaman * ukuran`
    if (mulai >= totalTugasDiServer) {
      return []; // Mengembalikan list kosong jika data sudah habis
    }

    return List.generate(ukuranHalaman, (index) {
      int nomorTugas = mulai + index + 1;
      if (nomorTugas > totalTugasDiServer) return null;
      
      return TugasPerforma(
        nomor: nomorTugas,
        mataKuliah: const [
          'Pemrograman Mobile', 'Basis Data', 'Jaringan Komputer',
          'Rekayasa Perangkat Lunak', 'Sistem Operasi', 'Kecerdasan Buatan',
        ][(nomorTugas - 1) % 6],
        status: nomorTugas % 4 == 0 ? StatusTugas.selesai : StatusTugas.aktif,
      );
    }).whereType<TugasPerforma>().toList();
  }
}