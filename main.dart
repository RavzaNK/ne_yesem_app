import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'data.dart'; 

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
      home: const HomePage(),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BiteWise Hakkında"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.info_outline, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              "Karar Vermek Artık Daha Lezzetli!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "BiteWise, yemek seçimi yaparken yaşanan kararsızlığı ortadan kaldırmak için geliştirilmiştir. "
              "Alerjen filtreleri ve kategori seçimleriyle size en uygun menüyü saniyeler içinde sunar.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const Spacer(),
            const Text("Versiyon 1.0.0 - Mock Data Modu", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Map<String, dynamic>> _foodDatabase = FoodData.database; 
  String _currentFood = "Karar Veremedin mi?";
  String _currentDrink = "";
  bool _isSpinning = false;
  String _selectedCategory = "Hepsi";
  final List<String> _excludedIngredients = [];

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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.orange),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange.shade50, Colors.white, Colors.orange.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildHeader()),
                const SizedBox(height: 40), // Üst boşluğu biraz artırdık
                
                _buildSectionHeader("Kategori Seçimi", Icons.restaurant_menu),
                _buildCategoryList(),
                
                const SizedBox(height: 25),
                
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

  // --- GÜNCELLENEN BAŞLIK ALANI (Sadece İkon ve İsim) ---
  Widget _buildHeader() {
    return const Column(
      children: [
        Icon(Icons.restaurant_menu_rounded, color: Colors.orange, size: 55),
        SizedBox(height: 12),
        Text(
          "BiteWise", 
          style: TextStyle(
            fontSize: 40, // Biraz daha büyüttük
            fontWeight: FontWeight.w900, 
            color: Colors.black87,
            letterSpacing: -0.5
          )
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange.shade900),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
        ],
      ),
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
              labelStyle: TextStyle(
                color: _selectedCategory == cat ? Colors.white : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
      runSpacing: 8,
      children: allergens.entries.map((entry) {
        final isSelected = _excludedIngredients.contains(entry.key);
        return FilterChip(
          label: Text(entry.value),
          selected: isSelected,
          onSelected: (val) => setState(() => val ? _excludedIngredients.add(entry.key) : _excludedIngredients.remove(entry.key)),
          selectedColor: Colors.orange.withOpacity(0.2),
          checkmarkColor: Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      }).toList(),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            _currentFood,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30, 
              fontWeight: FontWeight.w900, 
              color: Colors.orange.shade900
            ),
          ),
          if (!_isSpinning && _currentDrink.isNotEmpty) ...[
            const Divider(height: 40),
            Text(
              _currentDrink, 
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.w600)
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumButton() {
    return ElevatedButton(
      onPressed: _isSpinning ? null : _spinTheWheel,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 75),
        backgroundColor: Colors.orange,
        elevation: 5,
        shadowColor: Colors.orange.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text(
        "🍔 Şansımı Dene", 
        style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)
      ),
    );
  }
}
