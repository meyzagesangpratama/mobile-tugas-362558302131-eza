import 'package:flutter/material.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../controllers/sesi_controller.dart';

/// Penjaga pintu: menampilkan form login atau beranda sesuai status sesi.
class GerbangSesi extends StatelessWidget {
  final SesiController controller;
  final Widget Function(BuildContext context) form;
  final Widget Function(BuildContext context, SesiPengguna sesi) beranda;

  const GerbangSesi({
    super.key,
    required this.controller,
    required this.form,
    required this.beranda,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? _) {
        final SesiPengguna? sesi = controller.sesi;

        if (controller.status == StatusSesi.memeriksa) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.status == StatusSesi.masuk && sesi != null) {
          return beranda(context, sesi);
        }

        // keluar, memproses, gagal, kedaluwarsa → tetap di form.
        return form(context);
      },
    );
  }
}