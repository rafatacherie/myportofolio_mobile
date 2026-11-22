// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Halaman menu menampilkan identitas dan tombol aksi', (
    WidgetTester tester,
  ) async {
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
    expect(find.text('View Portfolio'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Add Experience'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    // Tombol yang tidak berpindah halaman hanya memunculkan SnackBar.
    await tester.tap(find.text('View Portfolio'));
    await tester.pump();
    expect(find.text('You tapped the View Portfolio button!'), findsOneWidget);
  });

  testWidgets('Kartu Add Project membuka halaman form proyek', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Project Name'), findsOneWidget);
    expect(find.text('Project Description'), findsOneWidget);
    expect(find.text('Technologies Used'), findsOneWidget);
    expect(find.text('Project URL'), findsOneWidget);
    expect(find.text('Project Image URL (optional)'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });

  testWidgets('Project form validates URLs and summarizes all fields', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Add Project'));
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    final formFields = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'TextFormField',
    );
    expect(formFields, findsNWidgets(5));

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Project name is required.'), findsOneWidget);
    expect(find.text('Project description is required.'), findsOneWidget);
    expect(find.text('Technologies used are required.'), findsOneWidget);
    expect(find.text('Project URL is required.'), findsOneWidget);

    await tester.enterText(formFields.at(0), 'Portfolio App');
    await tester.enterText(formFields.at(1), 'A mobile portfolio application.');
    await tester.enterText(formFields.at(2), 'Flutter, Dart');
    await tester.ensureVisible(formFields.at(3));
    await tester.enterText(formFields.at(3), 'not-a-url');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('Enter a valid URL starting with http:// or https://.'),
      findsOneWidget,
    );
    expect(find.text('Project Name: Portfolio App'), findsNothing);

    await tester.ensureVisible(formFields.at(3));
    await tester.enterText(formFields.at(3), 'https://example.com/portfolio');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Project Name: Portfolio App'), findsOneWidget);
    expect(
      find.text('Project Description: A mobile portfolio application.'),
      findsOneWidget,
    );
    expect(find.text('Technologies Used: Flutter, Dart'), findsOneWidget);
    expect(
      find.text('Project URL: https://example.com/portfolio'),
      findsOneWidget,
    );
    expect(find.text('Project Image URL: Not provided'), findsOneWidget);
  });

  testWidgets('Kartu Add Experience membuka halaman form pengalaman', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Add Experience Form'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });

  testWidgets('Drawer dapat membuka form pengalaman dan kembali ke Home', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Experience').last);
    await tester.pumpAndSettle();

    expect(find.text('Add Experience Form'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('Form pengalaman menampilkan error dan ringkasan setelah valid', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Add Experience'));
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Experience name is required.'), findsOneWidget);
    expect(find.text('Position/role is required.'), findsOneWidget);
    expect(find.text('Description is required.'), findsOneWidget);
    expect(find.text('Start date is required.'), findsOneWidget);
    expect(find.text('Name: Konferensi Flutter'), findsNothing);

    final formFields = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'TextFormField',
    );
    expect(formFields, findsNWidgets(5));

    await tester.enterText(formFields.at(0), 'Konferensi Flutter');
    await tester.enterText(formFields.at(1), 'Peserta');
    await tester.enterText(formFields.at(2), 'Mengikuti sesi Flutter.');

    await tester.ensureVisible(formFields.at(3));
    await tester.tap(formFields.at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Start date is required.'), findsNothing);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Experience name is required.'), findsNothing);
    expect(find.text('Position/role is required.'), findsNothing);
    expect(find.text('Description is required.'), findsNothing);
    expect(find.text('Start date is required.'), findsNothing);
    expect(find.text('Name: Konferensi Flutter'), findsOneWidget);
    expect(find.text('Position/Role: Peserta'), findsOneWidget);
    expect(find.text('Description: Mengikuti sesi Flutter.'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Name: Konferensi Flutter'), findsNothing);
    expect(find.text('Add Experience Form'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}