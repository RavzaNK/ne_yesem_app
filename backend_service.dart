import 'models.dart';
import 'data.dart';

class BackendService {
  // Singleton yapısı (Uygulamanın her yerinden aynı backend verisine ulaşmak için)
  static final BackendService _instance = BackendService._internal();
  factory BackendService() => _instance;
  BackendService._internal();

  // Aktif kullanıcıyı hafızada tutuyoruz (In-Memory Database)
  UserProfile? _currentUser;

  // 1. KULLANICI GİRİŞ İŞLEMLERİ
  void loginAsUser(String name) {
    _currentUser = UserProfile(username: name, isGuest: false, foodHistory: []);
  }

  void loginAsGuest() {
    _currentUser = UserProfile(username: "Misafir Kullanıcı", isGuest: true, foodHistory: []);
  }

  UserProfile? getCurrentUser() => _currentUser;
  void logout() => _currentUser = null;

  // 2. VERİ KAYDETME İŞLEMİ (Geçmişe yemek ekleme)
  void saveFoodToHistory(String foodName) {
    if (_currentUser != null) {
      _currentUser!.foodHistory.add(foodName);
    }
  }

  // 3. AI FARKINDALIK VE İSTATİSTİK MOTORU
  Map<String, dynamic> getAIFeedback() {
    if (_currentUser == null || _currentUser!.foodHistory.isEmpty) {
      return {
        'status': 'neutral',
        'message': 'Henüz yeterli veri yok. Şansını denemeye başla!'
      };
    }

    List<String> history = _currentUser!.foodHistory;
    int totalSelections = history.length;

    // Kategorileri sayalım
    int sweetCount = 0;
    int heavyCount = 0; // Acı ve burger gibi ağır şeyler
    int lightCount = 0; // Hafif ve vejetaryen

    for (var food in history) {
      var foodInfo = FoodData.database[food];
      if (foodInfo != null) {
        String cat = foodInfo['cat'];
        if (cat == '🍰 Tatlı') sweetCount++;
        if (cat == '🔥 Acı' || food.contains('Burger') || food.contains('Kebap')) heavyCount++;
        if (cat == '🥗 Hafif' || cat == '🌿 Vejetaryen') lightCount++;
      }
    }

    // AI Farkındalık Algoritması (Kural Tabanlı AI Simülasyonu)
    if (sweetCount / totalSelections > 0.5) {
      return {
        'status': 'warning',
        'message': '🚨 AI Uyarısı: Son zamanlarda hep tatlı şeylere yöneliyorsun. Kan şekerine biraz dikkat mi etsen? 🍏'
      };
    } else if (heavyCount / totalSelections > 0.6) {
      return {
        'status': 'warning',
        'message': '🍔 AI Analizi: Canın hep ağır ve baharatlı şeyler istiyor gibi. Midene farkındalık kazandırmak için bir sonraki öğünde yeşilliklere şans ver!'
      };
    } else if (lightCount / totalSelections > 0.6) {
      return {
        'status': 'success',
        'message': '🌿 AI Tebriği: Harika gidiyorsun! Dengeli ve hafif seçimlerin vücuduna çok iyi bakıyor. Aynen devam! 🥗'
      };
    }

    return {
      'status': 'neutral',
      'message': '🤖 AI Analizi: Beslenme düzenin şu an gayet dengeli görünüyor. Seçim yapmaya devam et!'
    };
  }
}
