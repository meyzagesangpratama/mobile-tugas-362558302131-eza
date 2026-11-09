enum StatusTugas { aktif, selesai }

class TugasPerforma {
  TugasPerforma({
    required this.nomor,
    required this.mataKuliah,
    required this.status,
  }) : kunciPencarian = 'Tugas praktikum ${nomor.toString().padLeft(4, '0')} $mataKuliah'.toLowerCase();

  final int nomor;
  final String mataKuliah;
  final StatusTugas status;  
  final String kunciPencarian;

  String get judul => 'Tugas praktikum ${nomor.toString().padLeft(4, '0')}';

  bool get selesai => status == StatusTugas.selesai;
}