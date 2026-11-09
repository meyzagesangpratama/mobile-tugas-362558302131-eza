import 'package:flutter/material.dart';
import '../data/sumber_tugas_contoh.dart';
import '../domain/filter_tugas.dart';
import '../domain/tugas_performa.dart';
import '../widgets/kartu_tugas_performa.dart';

class DaftarTugasPerformaScreen extends StatefulWidget {
  const DaftarTugasPerformaScreen({super.key});

  @override
  State<DaftarTugasPerformaScreen> createState() => _DaftarTugasPerformaScreenState();
}

class _DaftarTugasPerformaScreenState extends State<DaftarTugasPerformaScreen> {
  final TextEditingController _pencarian = TextEditingController();
  
  // State penyimpan hasil
  List<TugasPerforma> _hasil = [];
  StatusTugas? _filter;
  String _kueri = '';

  @override
  void initState() {
    super.initState();
    _terapkan(); // Jalankan filter pertama kali dibuka
  }

  // Fungsi untuk memperbarui state _hasil
  void _terapkan() {
    setState(() {
      _hasil = filterTugas(sumberTugasContoh, _kueri, _filter);
    });
  }

  @override
  void dispose() {
    _pencarian.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas Kuliah')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              key: const ValueKey('task-search'),
              controller: _pencarian,
              onChanged: (value) {
                _kueri = value;
                _terapkan(); // Panggil fungsi terapkan
              },
              decoration: const InputDecoration(
                labelText: 'Cari tugas atau mata kuliah',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: [
                _filterChip('Semua', null),
                _filterChip('Aktif', StatusTugas.aktif),
                _filterChip('Selesai', StatusTugas.selesai),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            // Gunakan _hasil.length dari state
            child: Text(
              'Menampilkan ${_hasil.length} dari ${sumberTugasContoh.length} tugas',
              key: const ValueKey('result-count'),
            ),
          ),
          Expanded(
            child: _hasil.isEmpty
                ? const Center(child: Text('Tidak ada tugas yang cocok.'))
                : ListView.builder(
                    key: const ValueKey('task-list'),
                    itemCount: _hasil.length,
                    itemBuilder: (context, index) => KartuTugasPerforma(tugas: _hasil[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, StatusTugas? status) => FilterChip(
        label: Text(label),
        selected: _filter == status,
        onSelected: (_) {
          _filter = status;
          _terapkan(); // Panggil fungsi terapkan
        },
      );
}