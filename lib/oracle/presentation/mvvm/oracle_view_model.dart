import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/core/constants/secrets.dart';
import 'package:gdg_campus_coffee/oracle/data/service/oracle_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class OracleViewModel extends ChangeNotifier {
  final OracleService _service = OracleService();
  final String _apiKey = Secrets.geminiApiKey;
  
  int _rights = 0;
  int get rights => _rights;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _currentFortune;
  String? get currentFortune => _currentFortune;

  String? _currentOmenTitle;
  String? get currentOmenTitle => _currentOmenTitle;

  OracleViewModel() {
    _service.streamFortuneRights().listen((count) {
      _rights = count;
      notifyListeners();
    });
  }

  Future<void> generateFortune() async {
    if (_rights <= 0) return;

    _isLoading = true;
    _currentFortune = null;
    notifyListeners();

    try {
      // Simulate/Implement Gemini Call
      // For this high-fidelity demo, we'll use a "Codex" prompt logic
      
      /* Real Implementation Placeholder:
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      final prompt = 'You are the Grounds Oracle from "Caffè & Codex". Generate a poetic, mystical, and philosophical coffee fortune (fal) about fate and future. Keep it under 40 words. Start with a title like THE SCHOLAR or THE VOYAGER.';
      final response = await model.generateContent([Content.text(prompt)]);
      _currentFortune = response.text;
      */

      // High-Fidelity Fallback Logic (Matches the reference image vibes)
      await Future.delayed(const Duration(seconds: 3)); // Dramatic pause for the ritual
      
      final fortunes = [
        {"title": "YAZICI", "content": "Eski bir metnin kenar boşluklarında derin bir keşif seni bekliyor. Gününün dipnotlarına dikkat et; en küçük ayrıntı en büyük gerçeği barındırır."},
        {"title": "GEZGİN", "content": "Telveler Doğu'ya doğru çökmüş. Ay küçülmeden önce seni her zamanki sınırlarının ötesine geçmeye davet eden bir çağrı gelecek. Ruhun yolculuğuna hazır ol."},
        {"title": "SİMYACI", "content": "Acı ve tatlı bugün fincanında dengesini buluyor. Zorlu bir dönüşüm altın meyvelerini veriyor; azmini arındıran ateşten korkma."},
        {"title": "MUHAFIZ", "content": "Önemli bir eşiğin önünde duruyorsun. Anahtar zorlamakta değil, yavaş demlenen bir kahvenin sabrında yatıyor. Netliğin yükselmesini bekle."},
        {"title": "DOKUMACI", "content": "Soğuk bir kahve eşliğinde yapılacak bir sohbet, kalıcı olarak koptuğunu sandığın bir bağı onaracak. Bağlantılarının dokusu sandığından daha dirençli."},
      ];

      final selection = fortunes[DateTime.now().millisecond % fortunes.length];
      _currentOmenTitle = selection["title"];
      _currentFortune = selection["content"];
      
      await _service.decrementRights();
    } catch (e) {
      _currentFortune = "The grounds are silent today. The stars obscure the vision.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
