import 'package:flutter/material.dart';

const _photoProfil = 'assets/images/images.jpg';
const _nomEtudiant = 'Sara El Amrani';
const _filiere = 'Informatique';
const _niveau = 'S5';
const _numeroEtudiant = 'EMSI-2026-015';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.indigo.shade100,
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
            const _CarteEtudiant(),
            const SizedBox(height: 24),

            // 3. Informations personnelles
            const Text(
              'Informations personnelles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _InfoProfil(
              icone: Icons.person,
              texte: 'Nom : $_nomEtudiant',
            ),
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
                    onPressed: () => debugPrint('Modifier le profil'),
                    child: const Text(
                      'Modifier le profil',
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icone, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(child: Text(texte)),
        ],
      ),
    );
  }
}

class _CarteEtudiant extends StatelessWidget {
  const _CarteEtudiant();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade700,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 48, 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(_photoProfil),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nomEtudiant,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$_filiere · $_niveau',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'N° étudiant : $_numeroEtudiant',
                        style: TextStyle(color: Colors.white),
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
              color: Colors.white70,
              size: 24,
              semanticLabel: 'Établissement',
            ),
          ),
        ],
      ),
    );
  }
}
