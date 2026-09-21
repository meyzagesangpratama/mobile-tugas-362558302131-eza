import 'package:flutter/material.dart';
import 'success_pages.dart';

class DetailPages extends StatelessWidget {
  const DetailPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.asset(
                'lib/assets/images/nasgor.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 80),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Nama Menu
            const Text(
              'Nasi Goreng',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // ✅ Harga
            const Text(
              'Harga: Rp15.000',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Deskripsi
            const Text(
              'Nasi goreng dengan telur, ayam, dan sayuran. Menu favorit di kantin kampus!',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const Spacer(),

            // ✅ Tombol Pesan Sekarang
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuccessPages(),
                  ),
                );
              },
              child: const Text('Pesan Sekarang'),
            ),
            const SizedBox(height: 12),

            // ✅ Tombol Kembali
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFF1976D2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}