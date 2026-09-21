import 'package:flutter/material.dart';
import 'detail_pages.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Kampus'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              ClipRRect(
                child: Image.asset(
                  'lib/assets/images/images.jpg',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 80),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Nasi Goreng',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Rp15.000',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Nasi goreng dengan telur, ayam, dan sayuran. Menu favorit di kantin kampus!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPages(),
                    ),
                  );
                },
                child: const Text('Lihat Detail'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}