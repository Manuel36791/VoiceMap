import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();
Future speak(String text) async{
  await flutterTts.setLanguage('ar');
  await flutterTts.setPitch(1);
  await flutterTts.speak(text);
}




