class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? regdate;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.regdate});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    regdate = json['regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['regdate'] = regdate;
    return data;
  }
}
