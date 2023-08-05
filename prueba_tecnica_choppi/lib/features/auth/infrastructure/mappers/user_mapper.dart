




import '../../domain/domain.dart';

class UserMapper {


  static User userJsonToEntity( Map<String,dynamic> json ) => User(
     id: json["id"],
     username: json["username"],
     email: json["email"],
     firstName: json["firstName"],
     lastName: json["lastName"],
     gender: json["gender"],
     image: json["image"],
     token: json['token'] ?? ''
  );

}

