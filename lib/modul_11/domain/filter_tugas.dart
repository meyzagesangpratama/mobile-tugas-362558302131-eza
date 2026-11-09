import 'tugas_performa.dart';

List<TugasPerforma> filterTugas(
  List<TugasPerforma> semuaTugas, 
  String kueri, 
  StatusTugas? filter,
) {
  final q = kueri.toLowerCase();
  return semuaTugas.where((tugas) {
    final cocokStatus = filter == null || tugas.status == filter;
    final cocokTeks = tugas.kunciPencarian.contains(q); 
    return cocokStatus && cocokTeks;
  }).toList(growable: false);
}