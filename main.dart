import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'data.dart'; // Az önce oluşturduğumuz veri dosyasını içeri aktarıyoruz

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
          seedColor: Colors.orange,
          surface: const Color(0xFFFFF9F5),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Veriyi data.dart içindeki FoodData sınıfından çekiyoruz
  final Map<String, Map<String, dynamic>> _foodDatabase = FoodData.database;

  String _currentFood = "Karar Veremedin mi?";
  String _currentDrink = "";
  String _lastResult = "";
  bool _isSpinning = false;
  String _selectedCategory = "Hepsi";
  final List<String> _excludedIngredients = [];

  void _spinTheWheel() {
    List<String> availableFoods = _foodDatabase.keys.where((food) {
      bool categoryMatch = (_selectedCategory == "Hepsi" || 
          _foodDatabase[food]!['cat'] == _selectedCategory);
      
      List<dynamic> foodIngs = _foodDatabase[food]!['ings'];
      bool hasExcludedIngredient = foodIngs.any(
        (ing) => _excludedIngredients.contains(ing),
      );

      return categoryMatch && !hasExcludedIngredient;
    }).toList();

    if (availableFoods.isEmpty) {
      setState(() {
        _currentFood = "Uygun seçenek bulunamadı! ❌";
        _currentDrink = "";
      });
      return;
    }
    
    if (availableFoods.length > 1) {
      availableFoods.remove(_lastResult);
    }

    setState(() {
      _isSpinning = true;
      _currentDrink = "";
    });

    int counter = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentFood = availableFoods[Random().nextInt(availableFoods.length)];
      });
      counter++;
      if (counter > 15) {
        timer.cancel();
        setState(() {
          _isSpinning = false;
          _lastResult = _currentFood;
          _currentDrink = "Eşleşen İçecek: ${_foodDatabase[_currentFood]!['drink']} 🥤";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF9F5), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "BiteWise",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                    ),
                  ),
                ),
                _buildHeader("Kategori Seçimi", Icons.restaurant_menu),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ["Hepsi", "🔥 Acı", "🌿 Vejetaryen", "🥗 Hafif", "🍰 Tatlı"].map((cat) {
                    return ChoiceChip(
                      label: Text(cat),
                      selected: _selectedCategory == cat,
                      onSelected: (val) => setState(() => _selectedCategory = cat),
                      selectedColor: Colors.orange,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selectedCategory == cat ? Colors.white : Colors.black87,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
                _buildHeader("Alerjenler", Icons.warning_amber_rounded),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: {
                    'gluten': '🍞 Gluten',
                    'süt': '🥛 Süt',
                    'et': '🥩 Et',
                    'şeker': '🍬 Şeker',
                    'balık': '🐟 Balık',
                  }.entries.map((entry) {
                    return FilterChip(
                      label: Text(entry.value),
                      selected: _excludedIngredients.contains(entry.key),
                      onSelected: (val) => setState(() {
                        val ? _excludedIngredients.add(entry.key) : _excludedIngredients.remove(entry.key);
                      }),
                      selectedColor: Colors.orange.withValues(alpha: 0.2),
                      checkmarkColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    );
                  }).toList(),
                ),
                const Spacer(),
                _buildResultCard(),
                const Spacer(),
                _buildActionButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 20),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange.shade900),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 10),
          )
        ],
        border: Border.all(color: Colors.orange.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            _currentFood,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: _isSpinning ? Colors.grey : Colors.orange.shade900,
            ),
          ),
          if (!_isSpinning && _currentDrink.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),
            Text(
              _currentDrink,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _isSpinning ? null : _spinTheWheel,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 70),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text(
        "🍀 Şansımı Dene",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
