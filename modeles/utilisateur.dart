// ignore_for_file: constant_identifier_names

class Utilisateur {
  String? id;
  bool? isAnonymous;
  String? email;

  Utilisateur();

  static const String CHAMP_ID = 'id';

  Utilisateur.fromMap(dynamic obj) {
    id = obj.id;
    isAnonymous = false;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[CHAMP_ID] = id;
    return map;
  }
}
