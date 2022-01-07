class UserData {
  String? uid;
  String? name;
  String? email;

  UserData({
    required this.uid,
    required this.name,
    required this.email
  });

  Map<String, dynamic> get map{
    return {
      'uid':  uid,
      'name': name,
      'email': email
    };
  }

  UserData.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        email = data['email'];
}