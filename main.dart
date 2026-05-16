import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'data.dart';
import 'backend_service.dart';
import 'models.dart';

void main() => runApp(const BiteWiseApp());

class BiteWiseApp extends StatelessWidget {
  const BiteWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiteWise: Ne Yesem?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
          surface: const Color(0xFFFDFDFD),
        ),
      ),
      home: const LoginSelectionPage(), // İlk açılış ekranı değişti
    );
  }
}

// --- 1. YENİ EKRAN: GİRİŞ VE MİSAFİR SEÇİM SAYFASI ---
class LoginSelectionPage extends StatefulWidget {
  const LoginSelectionPage({super.key});

  @override
  State<LoginSelectionPage> createState() => _LoginSelectionPageState();
}

class _LoginSelectionPageState extends State<LoginSelectionPage> {
  final TextEditingController _nameController = TextEditingController();
  final BackendService _backend = BackendService();

  void _submitLogin() {
    if (_nameController.text.trim().isNotEmpty) {
      _backend.loginAsUser(_nameController.text.trim());
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange.shade100, Colors.white])),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu_rounded, size: 80, color: Colors.orange),
              const SizedBox(height: 16),
              const Text("BiteWise'a Hoş Geldin", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("AI Destekli Akıllı Gastronomi Rehberi", style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'İsminiz nedir?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitLogin,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 55), backgroundColor: Colors.orange),
                child: const Text("Kayıtlı Kullanıcı Olarak Gir", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  _backend.loginAsGuest();
                  _navigateToHome();
                },
                child: const Text("Misafir Kullanıcı Olarak Devam Et", style: TextStyle(fontSize: 16, color: Colors.deepOrange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. EKRAN: ANA SAYFA (Güncellendi) ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Map<String, dynamic>> _foodDatabase = FoodData.database;
  final BackendService _backend = BackendService();
  
  String _currentFood = "Karar Veremedin mi?";
  String _currentDrink = "";
  bool _isSpinning = false;
  String _selectedCategory = "Hepsi";
  final List<String> _excludedIngredients = [];
  UserProfile? user;

  @override
  void initState() {
    super.initState();
    user = _backend.getCurrentUser(); // Giriş yapan kullanıcıyı backend'den alıyoruz
  }

  void _spinTheWheel() {
    List<String> availableFoods = _foodDatabase.keys.where((food) {
      bool categoryMatch = (_selectedCategory == "Hepsi" || _foodDatabase[food]!['cat'] == _selectedCategory);
      List<dynamic> foodIngs = _foodDatabase[food]!['ings'];
      bool hasExcludedIngredient = foodIngs.any((ing) => _excludedIngredients.contains(ing));
      return categoryMatch && !hasExcludedIngredient;
    }).toList();

    if (availableFoods.isEmpty) {
      setState(() {
        _currentFood = "Uygun seçenek bulunamadı! ❌";
        _currentDrink = "";
      });
      return;
    }

    setState(() => _isSpinning = true);

    int counter = 0;
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        _currentFood = availableFoods[Random().nextInt(availableFoods.length)];
      });
      counter++;
      if (counter > 20) {
        timer.cancel();
        setState(() {
          _isSpinning = false;
          _currentDrink = "Günün Eşleşmesi: ${_foodDatabase[_currentFood]!['drink']} 🥤";
          
          // VERİYİ BACKEND'E KAYDEDİYORUZ
          _backend.saveFoodToHistory(_currentFood);
        });
      }
    });
  }

  // AI Farkındalık Pop-up penceresi
  void _showAIReport() {
    var aiResult = _backend.getAIFeedback();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [Icon(Icons.psychology, color: Colors.orange), SizedBox(width: 10), Text("AI Farkındalık Raporu")],
        ),
        content: Text(aiResult['message'], style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merhaba, ${user?.username ?? 'Ziyaretçi'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.deepOrange),
            tooltip: 'AI Analizi',
            onPressed: _showAIReport, // Sizin istediğiniz istatistik butonu!
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () {
              _backend.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginSelectionPage()));
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange.shade50, Colors.white])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSectionHeader("Kategori Seçimi", Icons.restaurant_menu),
                _buildCategoryList(),
                const SizedBox(height: 20),
                _buildSectionHeader("Alerjen Filtresi", Icons.warning_amber_rounded),
                _buildAllergenList(),
                const Spacer(),
                _buildResultCard(),
                const Spacer(),
                _buildPremiumButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange.shade900),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildCategoryList() {
    final categories = ["Hepsi", "🔥 Acı", "🌿 Vejetaryen", "🥗 Hafif", "🍰 Tatlı"];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: _selectedCategory == cat,
              onSelected: (_) => setState(() => _selectedCategory = cat),
              selectedColor: Colors.orange,
              labelStyle: TextStyle(color: _selectedCategory == cat ? Colors.white : Colors.orange, fontWeight: FontWeight.bold),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllergenList() {
    final allergens = {'gluten': '🍞 Gluten', 'süt': '🥛 Süt', 'et': '🥩 Et', 'şeker': '🍬 Şeker'};
    return Wrap(
      spacing: 8,
      children: allergens.entries.map((entry) {
        final isSelected = _excludedIngredients.contains(entry.key);
        return FilterChip(
          label: Text(entry.value),
          selected: isSelected,
          onSelected: (val) => setState(() => val ? _excludedIngredients.add(entry.key) : _excludedIngredients.remove(entry.key)),
        );
      }).toList(),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 40)]),
      child: Column(
        children: [
          Text(_currentFood, textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.orange.shade900)),
          if (!_isSpinning && _currentDrink.isNotEmpty) ...[
            const Divider(height: 40),
            Text(_currentDrink, style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumButton() {
    return ElevatedButton(
      onPressed: _isSpinning ? null : _spinTheWheel,
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 75), backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: const Text("🍔 Şansımı Dene", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
