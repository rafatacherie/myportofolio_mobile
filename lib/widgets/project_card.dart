import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

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
          // Navigasi ke halaman yang sesuai.
          if (item.name == "Add Project") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          } else if (item.name == "Add Experience") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExperienceFormPage(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text("You tapped the ${item.name} button!")),
              );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
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