import 'package:flutter/material.dart';

import 'about_page.dart';
import 'courses_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    void openPage(Widget page) {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(builder: (_) => page),
      );
    }

    void openFromDrawer(Widget page) {
      Navigator.pop(context);
      openPage(page);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EMSI Connect'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications),
            onPressed: () {
              debugPrint('Notifications consultées');
            },
          ),
          IconButton(
            tooltip: 'À propos',
            icon: const Icon(Icons.info_outline),
            onPressed: () => openPage(const AboutPage()),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: colors.primary),
              accountName: const Text('Étudiant EMSI'),
              accountEmail: const Text('etudiant@emsi.ma'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: colors.onPrimary,
                child: Icon(Icons.person, color: colors.primary),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Mes cours'),
              onTap: () => openFromDrawer(const CoursesPage()),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mon profil'),
              onTap: () => openFromDrawer(const ProfilePage()),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Paramètres'),
              onTap: () => openFromDrawer(const SettingsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos'),
              onTap: () => openFromDrawer(const AboutPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/emsi_logo.png',
                height: 160,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenue sur EMSI Connect',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ton campus à portée de main',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Votre espace universitaire pour accéder à vos cours, '
                'votre planning et vos informations personnelles.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final nombreColonnes = constraints.maxWidth < 600 ? 2 : 3;

                  return GridView.count(
                    crossAxisCount: nombreColonnes,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 110,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _Rubrique(
                        icon: Icons.menu_book,
                        label: 'Mes cours',
                        onTap: () => openPage(const CoursesPage()),
                      ),
                      const _Rubrique(
                        icon: Icons.calendar_month,
                        label: 'Planning',
                      ),
                      _Rubrique(
                        icon: Icons.person,
                        label: 'Mon profil',
                        onTap: () => openPage(const ProfilePage()),
                      ),
                      const _Rubrique(
                        icon: Icons.task_alt,
                        label: 'Mes tâches',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter',
        onPressed: () {
          debugPrint('Fonctionnalité bientôt disponible');
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class _Rubrique extends StatelessWidget {
  const _Rubrique({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: colors.onPrimaryContainer),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
