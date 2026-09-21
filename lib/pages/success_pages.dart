import 'package:flutter/material.dart';

class SuccessPages extends StatelessWidget {
  const SuccessPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Lingkaran hijau dengan centang putih
            Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 90,
              ),
            ),
            const SizedBox(height: 32),

            // ✅ Judul
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Deskripsi
            const Text(
              'Nasi Goreng sedang diproses.\nTerima kasih telah memesan di Kantin Kampus.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),

            // ✅ Tombol Kembali ke Menu
            ElevatedButton(
              onPressed: () {
                // ✅ popUntil → kembali ke halaman paling awal (HomePage)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Kembali ke Menu'),
            ),
          ],
        ),
      ),
    );
  }
}