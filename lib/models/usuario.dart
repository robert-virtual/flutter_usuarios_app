class Usuario {
  int id;
  String nombre;
  String email;
  bool activo;
  String createdAt;
  String updatedAt;
  Usuario(
      {required this.id,
      required this.nombre,
      required this.email,
      required this.activo,
      required this.createdAt,
      required this.updatedAt});

  factory Usuario.fromJson(Map json) {
    return Usuario(
        id: json["id"],
        nombre: json["nombre"],
        email: json["email"],
        activo: json["activo"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"]);
  }
}
