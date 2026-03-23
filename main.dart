import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const NeYesemApp());

class NeYesemApp extends StatelessWidget {
  const NeYesemApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          background: const Color(0xFFFFF9F5),
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
  // --- GURME VERİ TABANI ---
  final Map<String, Map<String, dynamic>> _foodDatabase = {
    '🍕 Margarita Pizza': {
      'cat': 'Hepsi',
      'drink': 'Fesleğenli Limonata',
      'ings': ['gluten', 'süt'],
    },
    '🌯 Adana Kebap': {
      'cat': '🔥 Acı',
      'drink': 'Acılı Şalgam',
      'ings': ['et'],
    },
    '🥗 Sezar Salata': {
      'cat': '🥗 Hafif',
      'drink': 'Maden Suyu',
      'ings': ['tavuk', 'gluten'],
    },
    '🍣 Sushi Roll': {
      'cat': '🥗 Hafif',
      'drink': 'Soğuk Yeşil Çay',
      'ings': ['balık'],
    },
    '🍔 Klasik Burger': {
      'cat': 'Hepsi',
      'drink': 'Buzlu Cola',
      'ings': ['et', 'gluten', 'süt'],
    },
    '🍝 Penne Arrabbiata': {
      'cat': '🔥 Acı',
      'drink': 'Üzüm Suyu',
      'ings': ['gluten'],
    },
    '🥘 Mantı': {
      'cat': 'Hepsi',
      'drink': 'Bol Köpüklü Ayran',
      'ings': ['et', 'gluten', 'süt'],
    },
    '🥙 Falafel Dürüm': {
      'cat': '🌿 Vejetaryen',
      'drink': 'Naneli Ayran',
      'ings': ['gluten'],
    },
    '🥗 Nohutlu Kinoa Salatası': {
      'cat': '🌿 Vejetaryen',
      'drink': 'Portakal Suyu',
      'ings': [],
    },
    '🍲 Mercimek Köftesi': {
      'cat': '🌿 Vejetaryen',
      'drink': 'Ev Yapımı Limonata',
      'ings': ['gluten'],
    },

    // TATLILAR (Şekerli ve Şekersiz Hepsi "🍰 Tatlı" Kategorisinde)
    '🧇 Belçika Waffle': {
      'cat': '🍰 Tatlı',
      'drink': 'Sütlü Kahve',
      'ings': ['gluten', 'süt', 'şeker'],
    },
    '🍮 Sütlaç': {
      'cat': '🍰 Tatlı',
      'drink': 'Demleme Çay',
      'ings': ['süt', 'şeker'],
    },
    '🍰 Cheesecake': {
      'cat': '🍰 Tatlı',
      'drink': 'Amerikano',
      'ings': ['gluten', 'süt', 'şeker'],
    },
    '🍌 Şekersiz Muzlu Puding': {
      'cat': '🍰 Tatlı',
      'drink': 'Sütlü Kahve',
      'ings': ['süt'],
    }, // İçinde şeker yok!
    '🥥 Hindistan Cevizli Fit Toplar': {
      'cat': '🍰 Tatlı',
      'drink': 'Bitki Çayı',
      'ings': [],
    }, // İçinde şeker yok!
    '🍎 Fırınlanmış Tarçınlı Elma': {
      'cat': '🍰 Tatlı',
      'drink': 'Adaçayı',
      'ings': [],
    }, // İçinde şeker yok!
  };

  String _currentFood = "Karar Veremedin mi?";
  String _currentDrink = "";
  String _lastResult = "";
  bool _isSpinning = false;
  String _selectedCategory = "Hepsi";
  final List<String> _excludedIngredients = [];

  void _spinTheWheel() {
    List<String> availableFoods = _foodDatabase.keys.where((food) {
      // 1. Kategori Filtresi
      bool categoryMatch =
          (_selectedCategory == "Hepsi" ||
          _foodDatabase[food]!['cat'] == _selectedCategory);

      // 2. Alerjen/Şeker Filtresi
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
    if (availableFoods.length > 1) availableFoods.remove(_lastResult);

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
          _currentDrink =
              "Eşleşen İçecek: ${_foodDatabase[_currentFood]!['drink']} 🥤";
        });
      }
    });
  }

  Widget _buildHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 20),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange.shade900),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
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
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "🍽️ Ne Yesem?",
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
                  children:
                      [
                            "Hepsi",
                            "🔥 Acı",
                            "🌿 Vejetaryen",
                            "🥗 Hafif",
                            "🍰 Tatlı",
                          ] // Şekersiz silindi
                          .map(
                            (cat) => ChoiceChip(
                              label: Text(cat),
                              selected: _selectedCategory == cat,
                              onSelected: (val) =>
                                  setState(() => _selectedCategory = cat),
                              selectedColor: Colors.orange,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedCategory == cat
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              showCheckmark: false,
                            ),
                          )
                          .toList(),
                ),

                _buildHeader("Alerjenler", Icons.warning_amber_rounded),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      {
                            'gluten': '🍞 Gluten',
                            'süt': '🥛 Süt',
                            'et': '🥩 Et',
                            'şeker':
                                '🍬 Şeker', // Şeker seçilirse tatlılar filtrelenecek!
                            'balık': '🐟 Balık',
                          }.entries
                          .map(
                            (entry) => FilterChip(
                              label: Text(entry.value),
                              selected: _excludedIngredients.contains(
                                entry.key,
                              ),
                              onSelected: (val) => setState(
                                () => val
                                    ? _excludedIngredients.add(entry.key)
                                    : _excludedIngredients.remove(entry.key),
                              ),
                              selectedColor: Colors.orange.withOpacity(0.2),
                              checkmarkColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                          .toList(),
                ),

                const Spacer(),

                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: _isSpinning
                                ? Colors.grey.shade400
                                : Colors.orange.shade900,
                          ),
                          child: Text(
                            _currentFood,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (!_isSpinning && _currentDrink.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Container(
                            height: 1,
                            color: Colors.grey.shade100,
                            width: 100,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _currentDrink,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: _isSpinning ? null : _spinTheWheel,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "🍀 Şansımı Dene",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
