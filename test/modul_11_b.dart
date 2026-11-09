import 'package:flutter_test/flutter_test.dart';
import 'package:poliwangi_mobile_starter/pengayaan/modul_11/presentation/pengendali_halaman.dart';

void main() {
  group('Test Pengendali Halaman (Pagination)', () {
    test('Muat awal mengambil 20 data', () async {
      final pengendali = PengendaliHalaman();
      expect(pengendali.daftarTugas.isEmpty, true);
      
      await pengendali.muatAwal();
      
      expect(pengendali.daftarTugas.length, 20);
      expect(pengendali.sedangMemuat, false);
    });

    test('Muat berikutnya menambah data', () async {
      final pengendali = PengendaliHalaman();
      await pengendali.muatAwal();
      await pengendali.muatBerikutnya();
      
      expect(pengendali.daftarTugas.length, 40);
    });

    test('Data berhenti dimuat jika sudah mencapai total 1000', () async {
      final pengendali = PengendaliHalaman();
      
      // Looping sampai data habis
      while (!pengendali.dataHabis) {
        await pengendali.muatBerikutnya();
      }
      
      // Pastikan total pas 1000 dan status dataHabis true
      expect(pengendali.daftarTugas.length, 1000);
      expect(pengendali.dataHabis, true);
    });
  });
}