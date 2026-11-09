import 'package:flutter/material.dart';
import '../presentation/pengendali_halaman.dart';
import '../data/sumber_tugas_berhalaman.dart';

class DaftarBerhalamanScreen extends StatefulWidget {
  const DaftarBerhalamanScreen({super.key});

  @override
  State<DaftarBerhalamanScreen> createState() => _DaftarBerhalamanScreenState();
}

class _DaftarBerhalamanScreenState extends State<DaftarBerhalamanScreen> {
  final ScrollController _scrollController = ScrollController();
  final PengendaliHalaman _pengendali = PengendaliHalaman();

  @override
  void initState() {
    super.initState();
    _pengendali.muatAwal(); // Load data pertama
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _pengendali.muatBerikutnya();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pengendali.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas (Berhalaman)')),
      body: ListenableBuilder(
        listenable: _pengendali,
        builder: (context, child) {
          final list = _pengendali.daftarTugas;
          if (list.isEmpty && _pengendali.sedangMemuat) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: list.length + (_pengendali.dataHabis ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == list.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final tugas = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${tugas.nomor}')),
                  title: Text(tugas.judul),
                  subtitle: Text(tugas.mataKuliah),
                  trailing: Text(tugas.status == StatusTugas.selesai ? 'Selesai' : 'Aktif'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}