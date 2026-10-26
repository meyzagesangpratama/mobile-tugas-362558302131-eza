import 'package:flutter/material.dart';

import '../../../modul_06/services/auth_api.dart';
import '../../../modul_06/widgets/field_kata_sandi.dart';
import '../controllers/sesi_controller.dart';
import '../repositories/sesi_repository.dart';

class LoginPengayaanScreen extends StatefulWidget {
  final SesiController controller;

  /// Daftar tempat penyimpanan yang dapat dipilih di layar ini.
  final List<SesiRepository> pilihan;

  const LoginPengayaanScreen({
    super.key,
    required this.controller,
    this.pilihan = const <SesiRepository>[],
  });

  @override
  State<LoginPengayaanScreen> createState() => _LoginPengayaanScreenState();
}

class _LoginPengayaanScreenState extends State<LoginPengayaanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _sandiCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _sandiCtrl.dispose();
    super.dispose();
  }

  String? _validasiEmail(String? nilai) {
    final String teks = (nilai ?? '').trim();
    if (teks.isEmpty) return 'Email wajib diisi.';
    if (!teks.contains('@') || !teks.contains('.')) {
      return 'Format email tidak valid.';
    }
    return null;
  }

  String? _validasiSandi(String? nilai) {
    if (nilai == null || nilai.isEmpty) return 'Kata sandi wajib diisi.';
    return null;
  }

  Future<void> _masuk() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await widget.controller.masuk(
      email: _emailCtrl.text,
      sandi: _sandiCtrl.text,
    );
    if (!mounted) return;
    _sandiCtrl.clear(); // Sandi tidak dibiarkan tersimpan di kolom.
  }

  @override
  Widget build(BuildContext context) {
    final SesiController c = widget.controller;
    final bool sibuk = c.status == StatusSesi.memproses;
    final ColorScheme warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Masuk — Pengayaan'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.lock_person_rounded,
                        size: 56, color: warna.primary),
                    const SizedBox(height: 16),
                    if (widget.pilihan.isNotEmpty) ...<Widget>[
                      _bangunPilihanPenyimpanan(c, sibuk),
                      const SizedBox(height: 16),
                    ],
                    if (c.pesan != null) ...<Widget>[
                      _KotakPesan(pesan: c.pesan!),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _emailCtrl,
                      enabled: !sibuk,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      validator: _validasiEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FieldKataSandi(
                      controller: _sandiCtrl,
                      enabled: !sibuk,
                      validator: _validasiSandi,
                      onSubmitted: _masuk,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: sibuk ? null : _masuk,
                      child: sibuk
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Masuk'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Akun demo: ${AuthApi.emailDemo} / ${AuthApi.sandiDemo}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bangunPilihanPenyimpanan(SesiController c, bool sibuk) {
    final int terpilih =
        widget.pilihan.indexWhere((SesiRepository r) => identical(r, c.repository));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Simpan sesi di:', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          segments: <ButtonSegment<int>>[
            for (int i = 0; i < widget.pilihan.length; i++)
              ButtonSegment<int>(value: i, label: Text(widget.pilihan[i].nama)),
          ],
          selected: <int>{if (terpilih >= 0) terpilih},
          emptySelectionAllowed: true,
          onSelectionChanged: sibuk
              ? null
              : (Set<int> pilih) {
                  if (pilih.isEmpty) return;
                  c.gunakanRepository(widget.pilihan[pilih.first]);
                },
        ),
        const SizedBox(height: 8),
        Text(
          c.repository.keterangan,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _KotakPesan extends StatelessWidget {
  final String pesan;

  const _KotakPesan({required this.pesan});

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warna.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.error_outline_rounded, color: warna.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(pesan, style: TextStyle(color: warna.onErrorContainer)),
          ),
        ],
      ),
    );
  }
}