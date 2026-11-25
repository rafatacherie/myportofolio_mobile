// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

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
  });

  testWidgets('View Portfolio fetches projects and opens project details', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final apiClient = ApiClient(
      baseUrl: 'https://test.example',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/projects/');
        return http.Response(
          jsonEncode([
            {
              'id': 'test-project',
              'title': 'Portfolio App',
              'description': 'A mobile portfolio application.',
              'tech_stack': 'Flutter, Dart',
              'project_url': 'https://example.com/portfolio',
              'project_image_url': '',
            },
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.tap(find.text('View Portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('Achievements: Projects'), findsOneWidget);
    expect(find.text('Portfolio App'), findsOneWidget);

    await tester.tap(find.text('Portfolio App'));
    await tester.pumpAndSettle();

    expect(find.text('Portfolio App'), findsNWidgets(2));
    expect(find.text('Tech stack: Flutter, Dart'), findsOneWidget);
    expect(find.text('A mobile portfolio application.'), findsOneWidget);
    expect(find.text('Link: https://example.com/portfolio'), findsOneWidget);
  });

  testWidgets('Add Project requires login before opening the form', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final apiClient = ApiClient(
      baseUrl: 'https://test.example',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/auth/token/');
        expect(jsonDecode(request.body), {
          'username': 'rafata',
          'password': 'secret',
        });
        return http.Response(
          jsonEncode({'token': 'test-token'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: apiClient));

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    final loginButton = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'ElevatedButton',
    );
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.text('Username cannot be empty!'), findsOneWidget);
    expect(find.text('Password cannot be empty!'), findsOneWidget);

    final loginFields = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'TextFormField',
    );
    await tester.enterText(loginFields.at(0), 'rafata');
    await tester.enterText(loginFields.at(1), 'secret');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Add New Project'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Project Name'), findsOneWidget);
    expect(find.text('Project Description'), findsOneWidget);
    expect(find.text('Technology Used'), findsOneWidget);
    expect(find.text('Project URL'), findsOneWidget);
    expect(find.text('Project Image URL'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });

  testWidgets('Project form validates fields and submits with auth token', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final apiClient = ApiClient(
      baseUrl: 'https://test.example',
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['Authorization'], 'Token test-token');
        expect(jsonDecode(request.body), {
          'title': 'Portfolio App',
          'description': 'A mobile portfolio application.',
          'tech_stack': 'Flutter, Dart',
          'project_url': 'https://example.com/portfolio',
          'project_image_url': '',
        });
        return http.Response(
          jsonEncode({
            'id': 'created-project',
            'title': 'Portfolio App',
            'description': 'A mobile portfolio application.',
            'tech_stack': 'Flutter, Dart',
            'project_url': 'https://example.com/portfolio',
            'project_image_url': '',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await tester.pumpWidget(
      MyApp(apiClient: apiClient, initialToken: 'test-token'),
    );
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

    expect(find.text('Title is required.'), findsOneWidget);
    expect(find.text('Description is required.'), findsOneWidget);
    expect(find.text('Technology used is required.'), findsOneWidget);
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
    expect(find.text('Project created successfully!'), findsNothing);

    await tester.ensureVisible(formFields.at(3));
    await tester.enterText(formFields.at(3), 'https://example.com/portfolio');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Project created successfully!'), findsOneWidget);
    expect(find.text('Portfolio App'), findsNWidgets(2));
  });

  testWidgets('Drawer guards Add Project and switches Login/Logout', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final apiClient = ApiClient(
      baseUrl: 'https://test.example',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(
            jsonEncode({'token': 'test-token'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/v1/auth/logout/') {
          expect(request.headers['Authorization'], 'Token test-token');
          return http.Response('', 204);
        }
        throw StateError(
          'Unexpected request: ${request.method} ${request.url}',
        );
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: apiClient));

    final drawer = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'Drawer',
    );
    final drawerLogin = find.descendant(
      of: drawer,
      matching: find.text('Login'),
    );
    final drawerLogout = find.descendant(
      of: drawer,
      matching: find.text('Logout'),
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(drawerLogin, findsOneWidget);
    expect(drawerLogout, findsNothing);

    await tester.tap(find.text('Add Project').last);
    await tester.pumpAndSettle();
    expect(find.text('Username'), findsNWidgets(2));

    final loginFields = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'TextFormField',
    );
    await tester.enterText(loginFields.at(0), 'rafata');
    await tester.enterText(loginFields.at(1), 'secret');
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == 'ElevatedButton',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add New Project'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(drawerLogout, findsOneWidget);
    expect(drawerLogin, findsNothing);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(drawerLogin, findsOneWidget);
    expect(drawerLogout, findsNothing);
  });

  testWidgets('Logout action card revokes the token and shows feedback', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final apiClient = ApiClient(
      baseUrl: 'https://test.example',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/auth/logout/');
        expect(request.headers['Authorization'], 'Token test-token');
        return http.Response('', 204);
      }),
    );
    await tester.pumpWidget(
      MyApp(apiClient: apiClient, initialToken: 'test-token'),
    );

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Logged out successfully.'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    final drawer = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'Drawer',
    );
    expect(
      find.descendant(of: drawer, matching: find.text('Login')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: drawer, matching: find.text('Logout')),
      findsNothing,
    );
  });

  testWidgets('Expired project token logs out and asks for login again', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    var createAttempts = 0;
    final apiClient = ApiClient(
      baseUrl: 'https://test.example',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/projects/') {
          createAttempts++;
          if (createAttempts == 1) {
            expect(request.headers['Authorization'], 'Token expired-token');
            return http.Response('{"detail":"Invalid token."}', 401);
          }
          expect(request.headers['Authorization'], 'Token fresh-token');
          return http.Response(
            jsonEncode({
              'id': 'created-project',
              'title': 'Portfolio App',
              'description': 'A mobile portfolio application.',
              'tech_stack': 'Flutter, Dart',
              'project_url': 'https://example.com/portfolio',
              'project_image_url': '',
            }),
            201,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/v1/auth/logout/') {
          expect(request.headers['Authorization'], 'Token expired-token');
          return http.Response('', 204);
        }
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(
            jsonEncode({'token': 'fresh-token'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        throw StateError(
          'Unexpected request: ${request.method} ${request.url}',
        );
      }),
    );
    await tester.pumpWidget(
      MyApp(apiClient: apiClient, initialToken: 'expired-token'),
    );
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    final projectFields = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'TextFormField',
    );
    await tester.enterText(projectFields.at(0), 'Portfolio App');
    await tester.enterText(
      projectFields.at(1),
      'A mobile portfolio application.',
    );
    await tester.enterText(projectFields.at(2), 'Flutter, Dart');
    await tester.enterText(
      projectFields.at(3),
      'https://example.com/portfolio',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    final loginFields = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'TextFormField',
    );
    await tester.enterText(loginFields.at(0), 'rafata');
    await tester.enterText(loginFields.at(1), 'secret');
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == 'ElevatedButton',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add New Project'), findsOneWidget);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(createAttempts, 2);
    expect(find.text('Project created successfully!'), findsOneWidget);
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

    expect(find.text('Add New Experience'), findsOneWidget);
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

    expect(find.text('Add New Experience'), findsOneWidget);

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
    expect(find.text('Add New Experience'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
