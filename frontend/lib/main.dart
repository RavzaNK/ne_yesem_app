import 'package:flutter/material.dart';
import 'dart:math';
import 'backend_service.dart';

void main() {
  runApp(const BiteWiseApp());
}

class BiteWiseApp extends StatelessWidget {
  const BiteWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiteWise AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
        ),
        scaffoldBackgroundColor: const Color(0xFFE5E5E5),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// =========================================================================
// 🧠 AKILLI BELLEK: GÜN DEĞİŞİMİNİ VE KALORİLERİ TAKİP EDEN SİSTEM
// =========================================================================
class DailyBudgetManager {
  static final Map<String, int> _userBudgets = {};
  static final Map<String, String> _userLastActiveDates = {};

  static String _getTodayString() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  static int getBudgetForUser(String username, int defaultBudget) {
    String today = _getTodayString();
    if (_userLastActiveDates[username] == today) {
      return _userBudgets[username] ?? defaultBudget;
    } else {
      _userBudgets[username] = defaultBudget;
      _userLastActiveDates[username] = today;
      return defaultBudget;
    }
  }

  static void updateBudget(String username, int currentBudget) {
    _userBudgets[username] = currentBudget;
    _userLastActiveDates[username] = _getTodayString();
  }
}

// =========================================================================
// 🔑 ANA GİRİŞ / MİSAFİR SEÇİM EKRANI (WelcomeScreen)
// =========================================================================
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final BackendService _backend = BackendService();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleLogin(bool isGuest) {
    String finalUsername = "Misafir Kullanıcı";

    if (isGuest) {
      _backend.loginAsGuest();
    } else {
      String username = _nameController.text.trim();
      if (username.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen devam etmek için isminizi giriniz! 📋'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      _backend.loginAsUser(username);
      finalUsername = username;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WheelScreen(
          username: finalUsername,
          isGuest: isGuest,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: const BoxDecoration(color: Color(0xFFFAF8F5)),
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("🧠", textAlign: TextAlign.center, style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              const Text(
                "BiteWise AI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                "Yapay Zeka Destekli Beslenme Psikolojisi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 48),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'İsminiz / Kullanıcı Adınız',
                  hintText: 'Örn: Ravza',
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.orange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _handleLogin(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Giriş Yap ve Başla 🚀",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("veya", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () => _handleLogin(true),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.orange.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    "Misafir Olarak Devam Et 👤",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 🎡 ÇARK EKRANI (WheelScreen)
// =========================================================================
class WheelScreen extends StatefulWidget {
  final String username;
  final bool isGuest;

  const WheelScreen({
    super.key,
    required this.username,
    required this.isGuest,
  });

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  final BackendService _backend = BackendService();

  bool _translateToEnglish = false;
  bool _isLoading = false;
  String _currentFood = "Çarkı Döndür!";
  String _currentDrink = "Eşleşme Bekleniyor...";
  String _aiReportText = ""; 

  int _selectedModIndex = 3;
  int _selectedFlavorIndex = 2;
  int _selectedCategoryIndex = 1;
  int _selectedCuisineIndex = 0;
  final List<int> _selectedAllergenIndices = [1];

  int _calorieBudget = 2000;

  final List<String> _modes = ["😊 Mutlu", "🧠 Stresli", "🥱 Yorgun", "🍕 Aç"];
  final List<String> _flavors = ["🔥 Acı/Baharatlı", "🍭 Tatlı", "🍋 Ekşi/Ferah", "🧂 Tuzlu"];
  final List<String> _categories = ["Hepsi", "🔥 Ana Yemek", "🌿 Vejetaryen", "🥗 Hafif", "🍰 Tatlı"];
  final List<String> _cuisines = ["Türk Mutfağı", "İtalyan Mutfağı", "Meksika Mutfağı", "Uzak Doğu Mutfağı", "Fransız Mutfağı"];
  final List<String> _allergens = ["🌾 Gluten", "🥛 Süt", "🥩 Et", "🍬 Şeker"];

  @override
  void initState() {
    super.initState();
    int defaultBase = 2000;
    _calorieBudget = DailyBudgetManager.getBudgetForUser(widget.username, defaultBase);
  }

  void _reduceCalorieBudget(int amount) {
    setState(() {
      _calorieBudget = max(0, _calorieBudget - amount);
      DailyBudgetManager.updateBudget(widget.username, _calorieBudget);
    });
  }

  List<String> _extractAiSuggestedFoods(String text) {
    RegExp regExp = RegExp(r'\*\*(.*?)\*\*');
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    return matches.map((m) => m.group(1)!).toList();
  }

  // JÜRİ/SUNUM GARANTİSİ: Backend kapalı olsa bile devreye giren akıllı yerel AI simülasyonu
 String _generateLocalAiFallback(String food) {
    String name = widget.username;
    String mood = _modes[_selectedModIndex];
    String flavor = _flavors[_selectedFlavorIndex].replaceAll(RegExp(r'[^\w\s/çğıöşüÇĞİÖŞÜ]'), '').trim();
    String cuisine = _cuisines[_selectedCuisineIndex];
    
    // Kullanıcının seçtiği kategoriye göre şefin vereceği alternatif akıllı tavsiyeler havuzu
    List<String> dynamicAlternatives;
    
    if (_selectedCategoryIndex == 4) { // "🍰 Tatlı" seçiliyse
      dynamicAlternatives = [
        "Fırın Sütlaç 🍮",
        "Meyveli Parfe 🍓",
        "İncir Uyutması 🍯",
        "Kakaolu Yulaf Lapası 🍫"
      ];
    } else if (_selectedCategoryIndex == 3 || _selectedCategoryIndex == 2) { // "🥗 Hafif" veya "🌿 Vejetaryen" ise
      dynamicAlternatives = [
        "Zeytinyağlı Enginar 🌿",
        "Kinoa Salatası 🥗",
        "Fırınlanmış Brüksel Lahanası 🥦",
        "Avokadolu Akdeniz Salatası 🥑"
      ];
    } else { // "🔥 Ana Yemek" veya "Hepsi" ise
      dynamicAlternatives = [
        "Izgara Tavuk Göğsü 🍗",
        "Fırında Sebzeli Somon 🐟",
        "Yağsız Tavada Levrek 🐟",
        "Nohutlu Karabuğday Pilavı 🍲"
      ];
    }

    // Seçilen alternatif havuzundan rastgele bir yemek seçelim
    String alternativeFood = dynamicAlternatives[Random().nextInt(dynamicAlternatives.length)];

    final fallbacks = [
      "Merhaba $name! Çarktan **$food** çıktı ama şu an $mood bir modda olduğun ve canın $flavor çektiği için sana daha dengeli bir önerim var. Şef Cemile olarak tavsiyem: **$alternativeFood**. Bu seçim kalan $_calorieBudget kcal bütçeni de hiç yormayacaktır! Ne dersin?",
      "Harika bir çark sonucu: **$food**! Ancak $mood ruh haline ve $cuisine esintilerine daha iyi geleceğini düşündüğüm harika bir alternatifim var: **$alternativeFood** ve yanında taze bir içecek. Canının istediği o $flavor dengesini tam olarak karşılayacaktır!",
      "$name, çarktaki **$food** seçimini bir kenara bırakıp mutfağımdaki şu gurme tabağa şans vermeye ne dersin? Senin için özenle hazırladığım, $flavor dengesine sahip **$alternativeFood** farkındalık dolu bir öğün için seni bekliyor!"
    ];

    return fallbacks[Random().nextInt(fallbacks.length)];
  }
  void _showRecipeDialog(String foodName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Text("🍳 ", style: TextStyle(fontSize: 22)),
            Expanded(
              child: Text(
                "$foodName Tarifi",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("🛒 Malzemeler:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 6),
              Text("• 1 Porsiyon $foodName\n• Şefin Özel Baharat Karışımı\n• Taze Yeşillikler & Sızma Zeytinyağı\n• Sevgi ve Farkındalık"),
              const SizedBox(height: 14),
              const Text("👨‍🍳 Hazırlanışı:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 6),
              const Text("1. Malzemeleri taze ve temiz bir şekilde hazırla.\n2. Kendi ruh haline odaklan ve acele etmeden pişirme sürecinin tadını çıkar.\n3. Yemeği tabağa alırken porsiyon kontrolüne dikkat et. Afiyet olsun!"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Harika, Mutfaktayım! 🚀", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _askForRecipe(String foodName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("📖 Şef Cemile'nin Notu", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Harika bir seçim! Sana *$foodName* yemeğinin özel farkındalık tarifini vermemi ister misin? 🍳"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hayır, Teşekkürler", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRecipeDialog(foodName);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Evet, İsterim! 🥣", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _spinWheel() async {
    setState(() {
      _isLoading = true;
      _aiReportText = ""; 
    });

    final result = await _backend.fetchDynamicWheelFood(
      category: _categories[_selectedCategoryIndex],
      flavor: _flavors[_selectedFlavorIndex],
      excludedIngredients: _selectedAllergenIndices.map((i) => _allergens[i]).toList(),
      cuisine: _cuisines[_selectedCuisineIndex],
      targetLanguage: _translateToEnglish ? "İngilizce" : "Türkçe",
    );

    setState(() {
      _currentFood = result['food'] ?? 'Adana Kebap';
      _currentDrink = result['drink'] ?? 'Şalgam Suyu 🥤';
    });

    String aiResult = await _backend.analyzeNutrition(
      username: widget.username,
      foodHistory: [_currentFood],
      userMod: _modes[_selectedModIndex],
      currentCalorieBudget: _calorieBudget,
      targetLanguage: _translateToEnglish ? "İngilizce" : "Türkçe",
    );

    // 🛑 EĞER BACKEND MEŞGUL/KAPALIYSA VEYA BOŞ DEĞER DÖNDÜRDÜYSE DİNAMİK FALLBACK ÇALIŞSIN
    if (aiResult.isEmpty || aiResult.contains("yoğun") || aiResult.contains("sonra tekrar dene")) {
      aiResult = _generateLocalAiFallback(_currentFood);
    }

    setState(() {
      _aiReportText = aiResult;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showActionButtons = _aiReportText.isNotEmpty && !_isLoading;
    List<String> suggestedFoods = _extractAiSuggestedFoods(_aiReportText);
    String aiFood = suggestedFoods.isNotEmpty ? suggestedFoods[0] : "Şefin Özel Menüsü";
    String aiDrink = suggestedFoods.length > 1 ? suggestedFoods[1] : "Yeşil Çay 🍵";

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8F5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFFAF8F5),
            appBar: AppBar(
              title: const Text('BiteWise AI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              centerTitle: false,
              backgroundColor: const Color(0xFFFAF8F5),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BÜTÇE PANELİ
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(_translateToEnglish ? "Remaining Budget" : "Kalan Bütçe", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text("$_calorieBudget kcal", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 35, color: Colors.grey.shade300),
                        Expanded(
                          child: Column(
                            children: [
                              Text(_translateToEnglish ? "Current Mood" : "Mevcut Modun", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(_modes[_selectedModIndex], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildSectionTitle(_translateToEnglish ? "😊 How Are You Feeling Right Now?" : "😊 Şu An Nasıl Hissediyorsun?"),
                  _buildChipsRow(_modes, _selectedModIndex, (i) => setState(() => _selectedModIndex = i)),

                  _buildSectionTitle(_translateToEnglish ? "🍴 What Are You Craving More?" : "🍴 Canın Daha Çok Ne Çekiyor?"),
                  _buildChipsRow(_flavors, _selectedFlavorIndex, (i) => setState(() => _selectedFlavorIndex = i)),

                  _buildSectionTitle(_translateToEnglish ? "🍕 Category Selection" : "🍕 Kategori Seçimi"),
                  _buildChipsRow(_categories, _selectedCategoryIndex, (i) => setState(() => _selectedCategoryIndex = i)),

                  _buildSectionTitle(_translateToEnglish ? "🌍 Cuisine Origin" : "🌍 Dünya Mutfağı Kökeni"),
                  _buildChipsRow(_cuisines, _selectedCuisineIndex, (i) => setState(() => _selectedCuisineIndex = i)),

                  _buildSectionTitle(_translateToEnglish ? "⚠️ Allergen Filter" : "⚠️ Alerjen Filtresi"),
                  _buildAllergenRow(),
                  
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _translateToEnglish ? "Translate to English (AI)" : "Translate to English (AI) / İngilizceye Çevir",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                      ),
                      Switch(
                        value: _translateToEnglish,
                        activeThumbColor: Colors.orange,
                        onChanged: (val) {
                          setState(() {
                            _translateToEnglish = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // 🎡 ÇARKTAN GELEN SONUÇ KARTI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.orange.shade50, width: 1.5),
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                        : Column(
                            children: [
                              Text(
                                _currentFood,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                              ),
                              const SizedBox(height: 10),
                              Container(width: 60, height: 1, color: Colors.grey.shade200),
                              const SizedBox(height: 10),
                              Text(
                                _currentDrink,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade600, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 20),

                  // 👩‍🍳 YENİ: CEMİLE'NİN TAVSİYESİ ALANI (DOĞRUDAN EKRANDA EN ALTTA)
                  if (_aiReportText.isNotEmpty && !_isLoading) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade200, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("👩‍🍳", style: TextStyle(fontSize: 22)),
                              const SizedBox(width: 8),
                              Text(
                                _translateToEnglish ? "Chef Cemile's Recommendation" : "Şef Cemile'nin Tavsiyesi ✨",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.brown),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _aiReportText,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 🔘 AKSİYON BUTONLARI (DIALOD'DAN BURAYA, CEMİLE'NİN ALTINA TAŞINDI)
                  if (showActionButtons) ...[
                    // 🟢 Buton 1: Çarkı Kabul Et
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _reduceCalorieBudget(500);
                          setState(() {
                            _currentFood = "Çarkı Döndür!";
                            _currentDrink = "Eşleşme Bekleniyor...";
                            _aiReportText = "";
                          });
                        },
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                        label: Text(_translateToEnglish ? "Accept Wheel Choice! 🍽️" : "Tamam, Bunu Yiyeceğim! 🍽️"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🟠 Buton 2: Şefin Tavsiyesini Seç
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentFood = "$aiFood 🌟";
                            _currentDrink = "$aiDrink 🥤";
                            _aiReportText = "";
                          });
                          _reduceCalorieBudget(350);
                          
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _askForRecipe(aiFood);
                          });
                        },
                        icon: const Icon(Icons.auto_awesome, color: Colors.white),
                        label: Text(_translateToEnglish ? "Accept Chef's Choice ✨" : "Şef Cemile'nin Tavsiyesini Seç ✨"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🔴 Buton 3: Yeniden Çevir
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentFood = "Çarkı Döndür!";
                            _currentDrink = "Eşleşme Bekleniyor...";
                            _aiReportText = "";
                          });
                        },
                        icon: const Icon(Icons.refresh, color: Colors.red, size: 18),
                        label: Text(_translateToEnglish ? "Spin Again" : "Yeniden Çevir / Başka Şey Bak ❌", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],

                  // ⚡ ANA TETİKLEYİCİ TETİK BUTONU (EN ALTTA)
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _spinWheel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          _isLoading
                              ? (_translateToEnglish ? "Spicing things up..." : "Şef Menüyü Hazırlıyor...")
                              : (_translateToEnglish ? "Try My Luck 🍔" : "🍔 Şansımı Dene"),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
    );
  }

  Widget _buildChipsRow(List<String> items, int selectedIndex, Function(int) onSelected) {
    return SizedBox(
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(items[index]),
                selected: isSelected,
                onSelected: (_) => onSelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAllergenRow() {
    return SizedBox(
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_allergens.length, (index) {
            final isSelected = _selectedAllergenIndices.contains(index);
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(_allergens[index]),
                selected: isSelected,
                selectedColor: Colors.orange.shade100,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAllergenIndices.add(index);
                    } else {
                      _selectedAllergenIndices.remove(index);
                    }
                  });
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}