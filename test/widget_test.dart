import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emsi_connect/main.dart';

void main() {
  testWidgets('Parcours EMSI Connect sur une fenêtre étroite', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 760);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> tapText(String label) async {
      final drawer = find.byType(Drawer);
      final target = drawer.evaluate().isEmpty
          ? find.text(label)
          : find.descendant(of: drawer, matching: find.text(label));
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    Future<void> openDrawer() async {
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(const MyApp());
    await tapText('Vérifier la saisie');
    expect(find.text('Email obligatoire'), findsOneWidget);
    expect(find.text('Mot de passe obligatoire'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'etudiant@emsi.ma',
    );
    await tester.enterText(find.byType(TextFormField).last, 'Emsi2026!');
    await tapText('Vérifier la saisie');
    expect(find.byType(GridView), findsOneWidget);

    await tapText('Mes cours');
    expect(find.text('Modules du semestre'), findsOneWidget);
    await tapText('Retour');

    await openDrawer();
    expect(find.text('etudiant@emsi.ma'), findsOneWidget);
    await tapText('Mon profil');
    await tapText('Modifier le nom');
    await tester.enterText(find.byType(TextFormField), 'Rim Sakine');
    await tapText('Valider');
    await tapText('Voir les détails');
    expect(find.text('Rim Sakine'), findsOneWidget);
    expect(find.text('Informatique'), findsOneWidget);
    await tapText('Retour');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await openDrawer();
    await tapText('Paramètres');
    await tapText('Notifications');
    await tapText('Mode compact');
    await tapText('Afficher les informations complémentaires');
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile).first).value,
      isFalse,
    );
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(1)).value,
      isTrue,
    );
    expect(find.textContaining('Ces préférences'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await openDrawer();
    await tapText('Paramètres');
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile).first).value,
      isTrue,
    );
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(1)).value,
      isFalse,
    );
    expect(find.textContaining('Ces préférences'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await openDrawer();
    await tapText('À propos');
    expect(find.text('Version pédagogique 1.0'), findsOneWidget);
    await tapText('Retour');
    await openDrawer();
    await tapText('Déconnexion');
    expect(find.text('Connexion'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(Scaffold))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });
}
