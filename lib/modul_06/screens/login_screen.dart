import 'package:flutter/material.dart';
 
import '../models/sesi_pengguna.dart';
import '../services/auth_api.dart';
import '../services/sesi_memori.dart';
import '../widgets/field_kata_sandi.dart';
import '../widgets/kartu_sesi.dart';
 
enum StatusMasuk { diam, memproses, gagal }
 
class LoginScreen extends StatefulWidget {
  final AuthApi api;
  final SesiMemori sesiMemori;
 
  const LoginScreen({
    super.key,
    required this.api,
    required this.sesiMemori,
  });
 
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _sandiCtrl = TextEditingController();
 
  StatusMasuk _status = StatusMasuk.diam;
  String? _pesan;
  SesiPengguna? _sesi;
 
  @override
  void initState() {
    super.initState();
    final SesiPengguna? tersimpan = widget.sesiMemori.baca();
    if (tersimpan != null) {
      if (tersimpan.sudahKedaluwarsa(DateTime.now())) {
        widget.sesiMemori.hapus();
        _pesan = 'Sesi Anda sudah berakhir. Silakan masuk kembali.';
      } else {
        _sesi = tersimpan;
      }
    }
  }
 
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
    if (_status == StatusMasuk.memproses) return; // Cegah tekan ganda.
    if (!(_formKey.currentState?.validate() ?? false)) return;
 
    FocusScope.of(context).unfocus();
    setState(() {
      _status = StatusMasuk.memproses;
      _pesan = null;
    });
 
    try {
      final SesiPengguna sesi = await widget.api.masuk(
        email: _emailCtrl.text,
        sandi: _sandiCtrl.text,
      );
      await widget.sesiMemori.simpan(sesi);
      if (!mounted) return;
      _sandiCtrl.clear(); 
      setState(() {
        _sesi = sesi;
        _status = StatusMasuk.diam;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = StatusMasuk.gagal;
        _pesan = e.pesan;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = StatusMasuk.gagal;
        _pesan = 'Terjadi kesalahan tak terduga. Silakan coba lagi.';
      });
    }
  }
 
  Future<void> _keluar() async {
    await widget.sesiMemori.hapus();
    if (!mounted) return;
    setState(() {
      _sesi = null;
      _status = StatusMasuk.diam;
      _pesan = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda telah keluar.')),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final SesiPengguna? sesi = _sesi;
 
    return Scaffold(
      appBar: AppBar(
        title: Text(sesi == null ? 'Masuk' : 'Beranda'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: sesi == null
                  ? _bangunFormulir(context)
                  : KartuSesi(
                      sesi: sesi,
                      sekarang: DateTime.now(),
                      onKeluar: _keluar,
                    ),
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _bangunFormulir(BuildContext context) {
    final bool sibuk = _status == StatusMasuk.memproses;
    final ColorScheme warna = Theme.of(context).colorScheme;
 
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(Icons.lock_person_rounded, size: 64, color: warna.primary),
          const SizedBox(height: 12),
          Text(
            'Masuk ke Akun',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          if (_pesan != null) ...<Widget>[
            _KotakPesan(pesan: _pesan!),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _emailCtrl,
            enabled: !sibuk,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            autofillHints: const <String>[AutofillHints.email],
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Masuk'),
          ),
          const SizedBox(height: 24),
          const _PetunjukAkunDemo(),
        ],
      ),
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
            child: Text(
              pesan,
              style: TextStyle(color: warna.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _PetunjukAkunDemo extends StatelessWidget {
  const _PetunjukAkunDemo();
 
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Akun demo',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            const Text('Email: ${AuthApi.emailDemo}'),
            const Text('Sandi: ${AuthApi.sandiDemo}'),
            const SizedBox(height: 6),
            Text(
              'Uji kegagalan: ${AuthApi.emailTerkunci} (akun terkunci) atau '
              '${AuthApi.emailServerGangguan} (server gangguan).',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
 