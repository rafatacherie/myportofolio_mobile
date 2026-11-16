// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Halaman menu menampilkan identitas dan tombol aksi',
      (WidgetTester tester) async {
    // Atur ukuran layar uji ke 540x1200 supaya tiga InfoCard
    // dan kisi tombol muat tanpa overflow.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verifikasi judul dan label kartu identitas tampil.
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Class'), findsOneWidget);

    // Verifikasi ketiga tombol aksi tampil.
    expect(find.text('Lihat Portofolio'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    // Tombol yang tidak berpindah halaman hanya memunculkan SnackBar.
    await tester.tap(find.text('Lihat Portofolio'));
    await tester.pump();
    expect(
      find.text('Kamu telah menekan tombol Lihat Portofolio!'),
      findsOneWidget,
    );
  });

  testWidgets('Tombol Tambah Proyek membuka halaman form proyek',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });
}