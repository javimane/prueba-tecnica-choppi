import 'package:flutter_dotenv/flutter_dotenv.dart';



class Environment {

  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

 static String apiUrlLogin = dotenv.env['API_URL_LOGIN'] ?? 'No está configurado el API_URL_LOGIN';
 static String apiUrl = dotenv.env['API_URL'] ?? 'No está configurado el API_URL';
}

