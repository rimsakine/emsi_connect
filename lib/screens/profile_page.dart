import 'package:flutter/material.dart';

import 'student_details_page.dart';

const _photoProfil = 'assets/images/images.jpg';
const _nomEtudiant = 'Sara El Amrani';
const _filiere = 'Informatique';
const _niveau = 'S5';
const _numeroEtudiant = 'EMSI-2026-015';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nom = _nomEtudiant;

  Future<void> _modifierNom() async {
    var saisie = _nom;
    final formKey = GlobalKey<FormState>();
    final nouveauNom = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifier le nom'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: _nom,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Nom complet'),
            onChanged: (value) => saisie = value,
            validator: (value) =>
                (value ?? '').trim().isEmpty ? 'Saisis un nom.' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, saisie.trim());
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );

    if (!mounted || nouveauNom == null) return;
    setState(() => _nom = nouveauNom);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Bandeau et avatar
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 110,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(_photoProfil),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Carte étudiant du défi bonus
            _CarteEtudiant(nom: _nom),
            const SizedBox(height: 24),

            // 3. Informations personnelles
            const Text(
              'Informations personnelles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _InfoProfil(icone: Icons.person, texte: 'Nom : $_nom'),
            const SizedBox(height: 12),
            const _InfoProfil(icone: Icons.work, texte: 'Filière : $_filiere'),
            const SizedBox(height: 12),
            const _InfoProfil(icone: Icons.school, texte: 'Niveau : $_niveau'),
            const SizedBox(height: 12),
            const _InfoProfil(
              icone: Icons.email,
              texte: 'Email : sara@example.com',
            ),
            const SizedBox(height: 12),
            const _InfoProfil(
              icone: Icons.calendar_month,
              texte: 'Année universitaire : 2026–2027',
            ),
            const SizedBox(height: 16),

            // 4. Boutons du profil
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _modifierNom,
                    child: const Text(
                      'Modifier le nom',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => debugPrint('Contacter'),
                    child: const Text('Contacter'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => StudentDetailsPage(
                      studentName: _nom,
                      program: _filiere,
                    ),
                  ),
                );
              },
              child: const Text('Voir les détails'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoProfil extends StatelessWidget {
  const _InfoProfil({required this.icone, required this.texte});

  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icone, color: colors.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(child: Text(texte)),
        ],
      ),
    );
  }
}

class _CarteEtudiant extends StatelessWidget {
  const _CarteEtudiant({required this.nom});

  final String nom;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 48, 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(_photoProfil),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nom,
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_filiere · $_niveau',
                        style: TextStyle(color: colors.onPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'N° étudiant : $_numeroEtudiant',
                        style: TextStyle(color: colors.onPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Icon(
              Icons.school,
              color: colors.onPrimary,
              size: 24,
              semanticLabel: 'Établissement',
            ),
          ),
        ],
      ),
    );
  }
}
