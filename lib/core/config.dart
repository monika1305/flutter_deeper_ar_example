
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final androidKey = dotenv.env['ANDROID_AR_LICENCE_KEY'] ?? 'YOUR_ANDROID_AR_LICENCE_KEY';
  static final iosKey = dotenv.env['IOS_AR_LICENCE_KEY'] ?? 'YOUR_IOS_AR_LICENCE_KEY';
}