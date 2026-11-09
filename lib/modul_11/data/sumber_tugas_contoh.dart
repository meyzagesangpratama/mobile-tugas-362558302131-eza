import '../domain/tugas_performa.dart';

final List<TugasPerforma> sumberTugasContoh = List<TugasPerforma>.generate(
  1000,
  (index) => TugasPerforma(
    nomor: index + 1,
    mataKuliah: const [
      'Pemrograman Mobile',
      'Basis Data',
      'Jaringan Komputer',
      'Rekayasa Perangkat Lunak',
      'Sistem Operasi',
      'Kecerdasan Buatan',
      'Pemrograman Web',
      'Analisis dan Perancangan Sistem',
    ][index % 8],
    status: (index + 1) % 4 == 0 ? StatusTugas.selesai : StatusTugas.aktif,
  ),
);