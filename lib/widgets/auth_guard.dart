import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Memastikan pengguna sudah login; jika belum, membuka [LoginScreen].
/// Mengembalikan true jika pengguna sudah (atau berhasil) login.
Future<bool> ensureLoggedIn(BuildContext context) async {
  // Sudah login: langsung izinkan
  if (context.read<AuthState>().isLoggedIn) return true;

  // Belum login: buka layar login, dan tunggu hasilnya (true jika login berhasil)
  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  return loggedIn ?? false;
}
