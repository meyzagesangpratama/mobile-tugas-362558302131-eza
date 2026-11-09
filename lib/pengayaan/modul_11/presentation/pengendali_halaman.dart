import 'package:flutter/foundation.dart';
import '../data/sumber_tugas_berhalaman.dart';

class PengendaliHalaman extends ChangeNotifier {
  final List<TugasPerforma> _daftarTugas = [];
  List<TugasPerforma> get daftarTugas => _daftarTugas;

  int _halamanSaatIni = 0;
  bool _sedangMemuat = false;
  bool _dataHabis = false;

  bool get sedangMemuat => _sedangMemuat;
  bool get dataHabis => _dataHabis;

  // Muat data pertama kali
  Future<void> muatAwal() async {
    if (_halamanSaatIni == 0) {
      await muatBerikutnya();
    }
  }

  Future<void> muatBerikutnya() async {
    if (_sedangMemuat || _dataHabis) return;

    _sedangMemuat = true;
    notifyListeners();

    final dataBaru = await SumberTugasBerhalaman.ambilHalaman(_halamanSaatIni + 1);

    if (dataBaru.isEmpty) {
      _dataHabis = true;
    } else {
      _halamanSaatIni++;
      _daftarTugas.addAll(dataBaru);
    }

    _sedangMemuat = false;
    notifyListeners();
  }
}