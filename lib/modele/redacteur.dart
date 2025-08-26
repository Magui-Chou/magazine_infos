class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;

  Redacteur({this.id, required this.nom, required this.prenom, required this.email});

  // Conversion objet -> Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // Conversion Map -> objet
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
}
