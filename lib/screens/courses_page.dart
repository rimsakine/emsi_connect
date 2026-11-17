import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Les deux derniers modules illustrent l'ajout de cartes depuis la liste.
    const modules = [
      (
        nom: 'Développement Multi-Plateforme',
        enseignant: 'Mme Aouraghe',
        heures: 32,
        icone: Icons.menu_book,
      ),
      (
        nom: 'Bases de données avancées',
        enseignant: 'M. Exemple',
        heures: 28,
        icone: Icons.storage,
      ),
      (
        nom: 'Réseaux informatiques',
        enseignant: 'Mme Exemple',
        heures: 24,
        icone: Icons.network_check,
      ),
      (
        nom: 'Intelligence artificielle',
        enseignant: 'M. Exemple',
        heures: 20,
        icone: Icons.psychology,
      ),
      (
        nom: 'Cybersécurité',
        enseignant: 'Mme Exemple',
        heures: 24,
        icone: Icons.security,
      ),
      (
        nom: 'Gestion de projet',
        enseignant: 'M. Exemple',
        heures: 20,
        icone: Icons.assignment,
      ),
      (
        nom: 'Systèmes d’exploitation',
        enseignant: 'Mme Exemple',
        heures: 30,
        icone: Icons.computer,
      ),
      (
        nom: 'Développement Web',
        enseignant: 'M. Exemple',
        heures: 32,
        icone: Icons.language,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes cours'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ce titre reste visible pendant le défilement.
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Modules du semestre',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    horizontalTitleGap: 8,
                    minLeadingWidth: 32,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.indigo.shade50,
                      foregroundColor: Colors.indigo.shade800,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      module.nom,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(module.icone, size: 16, color: Colors.indigo),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Enseignant : ${module.enseignant}\n'
                              'Volume horaire : ${module.heures} h',
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text('Module sélectionné : ${module.nom}'),
                          ),
                        );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
