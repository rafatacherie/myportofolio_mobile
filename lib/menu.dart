import 'package:flutter/material.dart';

// Model data satu tombol menu: nama, ikon, dan warna latar kartu.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Identitas pemilik portofolio.
  final String npm = "2506621592";
  final String nama = "Rafata Zahi Cherie";
  final String kelas = "PBP C";

  // Tiga tombol aksi dengan warna berbeda.
  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Portofolio", Icons.folder, Colors.blue),
    ItemHomepage("Tambah Item", Icons.add_circle, Colors.green),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      // AppBar menampilkan bar bagian atas halaman aplikasi.
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // SingleChildScrollView mencegah overflow saat jendela lebar/pendek.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tiga InfoCard sejajar: NPM, Name, Class.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoCard(title: 'NPM', content: npm),
                  InfoCard(title: 'Name', content: nama),
                  InfoCard(title: 'Class', content: kelas),
                ],
              ),

              const SizedBox(height: 16.0),

              // Pesan sambutan dan kisi tombol menu.
              Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Selamat datang di MyPortfolio Mobile!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),

                    // Wrap biasa menghindari viewport bersarang yang dapat
                    // menahan scroll mouse pada Flutter Web.
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = width >= 900 ? 3 : width >= 600 ? 2 : 1;
                          final ratio = width >= 900 ? 2.0 : width >= 600 ? 1.6 : 2.5;
                          final cardWidth =
                              (width - 10 * (columns - 1)) / columns;

                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: items.map((ItemHomepage item) {
                              return SizedBox(
                                width: cardWidth,
                                height: cardWidth / ratio,
                                child: ItemCard(item),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget reusable: kartu informasi (judul + isi).
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        // Lebar kartu menyesuaikan proporsi layar (dibagi 3.8 agar tidak overflow).
        width: MediaQuery.of(context).size.width / 3.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reusable: kartu tombol aksi dengan efek sentuh dan SnackBar.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Warna diambil dari item, jadi tiap tombol punya warna berbeda.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi saat kartu ditekan.
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}