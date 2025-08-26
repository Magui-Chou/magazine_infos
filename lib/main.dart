import 'package:flutter/material.dart';
import 'database/database_manager.dart';
import 'modele/redacteur.dart';

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Rédacteurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const PageAccueil(),
    );
  }
}

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<Redacteur> redacteurs = [];

  @override
  void initState() {
    super.initState();
    _loadRedacteurs();
  }

  // Charger tous les rédacteurs
  Future<void> _loadRedacteurs() async {
    final data = await DatabaseManager.instance.getRedacteurs();
    setState(() {
      redacteurs = data;
    });
  }

  // Ajouter un rédacteur
  Future<void> _addRedacteur() async {
    if (nomController.text.isEmpty ||
        prenomController.text.isEmpty ||
        emailController.text.isEmpty) return;

    final newRedacteur = Redacteur(
      nom: nomController.text,
      prenom: prenomController.text,
      email: emailController.text,
    );

    await DatabaseManager.instance.insertRedacteur(newRedacteur);
    nomController.clear();
    prenomController.clear();
    emailController.clear();

    _loadRedacteurs();
  }

  // Supprimer un rédacteur
  Future<void> _deleteRedacteur(int id) async {
    await DatabaseManager.instance.deleteRedacteur(id);
    _loadRedacteurs();
  }

  // Modifier un rédacteur
  Future<void> _editRedacteur(Redacteur redacteur) async {
    final nomEdit = TextEditingController(text: redacteur.nom);
    final prenomEdit = TextEditingController(text: redacteur.prenom);
    final emailEdit = TextEditingController(text: redacteur.email);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier le rédacteur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomEdit, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: prenomEdit, decoration: const InputDecoration(labelText: "Prénom")),
            TextField(controller: emailEdit, decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              final updated = Redacteur(
                id: redacteur.id,
                nom: nomEdit.text,
                prenom: prenomEdit.text,
                email: emailEdit.text,
              );
              await DatabaseManager.instance.updateRedacteur(updated);
              Navigator.pop(context);
              _loadRedacteurs();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Rédacteurs"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            print("Menu cliqué");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print("Recherche cliquée");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulaire d'ajout
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: prenomController,
              decoration: const InputDecoration(labelText: "Prénom"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addRedacteur,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Ajouter"),
            ),
            const SizedBox(height: 20),

            // Liste des rédacteurs
            Expanded(
              child: ListView.builder(
                itemCount: redacteurs.length,
                itemBuilder: (context, index) {
                  final r = redacteurs[index];
                  return Card(
                    child: ListTile(
                      title: Text("${r.prenom} ${r.nom}"),
                      subtitle: Text(r.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editRedacteur(r),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRedacteur(r.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
