class Usuario {
  String id;
  String nombre;
  String email;
  bool activo;
  String createdAt;
  String updatedAt;
  String? accessToken;
  String? refreshToken;
  Usuario(
      {required this.id,
      required this.nombre,
      required this.email,
      required this.activo,
      required this.createdAt,
      required this.updatedAt,
       this.accessToken,
       this.refreshToken
      });

  factory Usuario.fromJson(Map json) {
    return Usuario(
        id: json["id"],
        nombre: json["nombre"],
        email: json["email"],
        activo: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"]
    );
  }
}
