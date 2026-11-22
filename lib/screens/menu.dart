import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

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
    ItemHomepage("View Portfolio", Icons.folder, Colors.blue),
    ItemHomepage("Add Project", Icons.add_circle, Colors.green),
    ItemHomepage("Add Experience", Icons.work, Colors.orange),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Ikon drawer (hamburger) dibuat putih agar terlihat di atas AppBar.
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Drawer menu untuk berpindah antarhalaman.
      drawer: const LeftDrawer(),
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
                        'Welcome to MyPortfolio Mobile!',
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
                          final columns = width >= 900
                              ? 3
                              : width >= 600
                              ? 2
                              : 1;
                          final ratio = width >= 900
                              ? 2.0
                              : width >= 600
                              ? 1.6
                              : 2.5;
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
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}