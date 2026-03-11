import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  final _uuid = const Uuid();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isFarmer => _currentUser?.role == UserRole.farmer;

  bool _isKannada = false;
  bool get isKannada => _isKannada;

  void toggleLanguage() {
    _isKannada = !_isKannada;
    notifyListeners();
  }

  // --- Auth Methods ---
  String _tempEmail = '';
  UserRole _tempRole = UserRole.farmer;

  Future<void> login(String email, String password, UserRole role) async {
    // Mock login
    await Future.delayed(const Duration(seconds: 1));
    _tempEmail = email;
    _tempRole = role;
    // Real flow would verify OTP, we just skip it or set it up
  }

  void verifyOtp(String otp, String name) {
    // Mock successful OTP verification
    _currentUser = AppUser(
      id: _uuid.v4(),
      name: name.isEmpty ? 'John Doe' : name,
      email: _tempEmail,
      role: _tempRole,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _cart.clear();
    notifyListeners();
  }

  // --- Products ---
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> get farmerProducts {
    if (_currentUser == null) return [];
    return _products.where((p) => p.farmerId == _currentUser!.id).toList();
  }

  void loadDummyData() {
    _products = [
      Product(
        id: 'p1',
        name: 'Fresh Apples',
        category: 'Fruits',
        pricePerKg: 120,
        imageUrl: 'assets/images/fresh_apples_transparent_1773120901646.png',
        farmerId: 'f1',
        pickupLocation: 'Farm A, Hubli',
        totalQuantity: 200,
      ),
      Product(
        id: 'p2',
        name: 'Fresh Carrots',
        category: 'Vegetables',
        pricePerKg: 40,
        imageUrl: 'assets/images/fresh_carrots_transparent_1773120902775.png',
        farmerId: 'f1',
        pickupLocation: 'Farm B, Dharwad',
        totalQuantity: 500,
      ),
      Product(
        id: 'p3',
        name: 'Wheat Grains',
        category: 'Grains',
        pricePerKg: 35,
        imageUrl: 'assets/images/wheat_grains_transparent_1773120905896.png',
        farmerId: 'f2',
        pickupLocation: 'Farm C, Gadag',
        totalQuantity: 1000,
      ),
      Product(
        id: 'p4',
        name: 'Almonds',
        category: 'Nuts',
        pricePerKg: 800,
        imageUrl: 'assets/images/almonds_transparent_1773120914750.png',
        farmerId: 'f3',
        pickupLocation: 'Farm D, Badami',
        totalQuantity: 50, // Rare maybe?
        isRare: true,
      ),
      Product(
        id: 'p5',
        name: 'Dragon Fruit',
        category: 'Fruits',
        pricePerKg: 250,
        imageUrl: 'assets/images/dragon_fruit_transparent_1773120915894.png',
        farmerId: 'f4',
        pickupLocation: 'Farm E, Mysore',
        totalQuantity: 30, // Rare
        isRare: true,
      ),
      Product(
        id: 'p6',
        name: 'Fresh Broccoli',
        category: 'Vegetables',
        pricePerKg: 60,
        imageUrl: 'assets/images/fresh_broccoli_transparent_1773120916793.png',
        farmerId: 'f1',
        pickupLocation: 'Farm A, Hubli',
        totalQuantity: 150,
      ),

      // --- Added catalog expansion ---
      Product(
        id: 'p7',
        name: 'Bananas',
        category: 'Fruits',
        pricePerKg: 55,
        imageUrl: 'assets/images/Bananas_fruit_isolated_transparent_transparent_1773121796257.png',
        farmerId: 'f2',
        pickupLocation: 'Farm F, Belagavi',
        totalQuantity: 350,
      ),
      Product(
        id: 'p8',
        name: 'Mangoes (Alphonso)',
        category: 'Fruits',
        pricePerKg: 180,
        imageUrl: 'assets/images/Mango_fruit_isolated_transparent_transparent_1773121803662.png',
        farmerId: 'f5',
        pickupLocation: 'Farm G, Karwar',
        totalQuantity: 120,
        isRare: true,
      ),
      Product(
        id: 'p9',
        name: 'Tomatoes',
        category: 'Vegetables',
        pricePerKg: 32,
        imageUrl: 'assets/images/Tomatoes_vegetable_isolated_transparent_transparent_1773121797357.png',
        farmerId: 'f3',
        pickupLocation: 'Farm H, Davanagere',
        totalQuantity: 600,
      ),
      Product(
        id: 'p10',
        name: 'Potatoes',
        category: 'Vegetables',
        pricePerKg: 28,
        imageUrl: 'assets/images/Potatoes_vegetable_isolated_transparent_transparent_1773121798199.png',
        farmerId: 'f1',
        pickupLocation: 'Farm B, Dharwad',
        totalQuantity: 900,
      ),
      Product(
        id: 'p11',
        name: 'Corn (Maize)',
        category: 'Grains',
        pricePerKg: 26,
        imageUrl: 'assets/images/Corn_maize_isolated_transparent_transparent_1773121800258.png',
        farmerId: 'f4',
        pickupLocation: 'Farm I, Bagalkot',
        totalQuantity: 1400,
      ),
      Product(
        id: 'p12',
        name: 'Rice (Sona Masuri)',
        category: 'Grains',
        pricePerKg: 58,
        imageUrl: 'assets/images/Rice_grains_sack_isolated_transparent_transparent_1773121799398.png',
        farmerId: 'f5',
        pickupLocation: 'Farm J, Raichur',
        totalQuantity: 2000,
      ),
      Product(
        id: 'p13',
        name: 'Cashews',
        category: 'Nuts',
        pricePerKg: 950,
        imageUrl: 'assets/images/Cashew_nuts_isolated_transparent_transparent_1773121801384.png',
        farmerId: 'f3',
        pickupLocation: 'Farm K, Udupi',
        totalQuantity: 80,
        isRare: true,
      ),
      Product(
        id: 'p14',
        name: 'Peanuts',
        category: 'Nuts',
        pricePerKg: 140,
        imageUrl: 'assets/images/Peanuts_nuts_isolated_transparent_transparent_1773121802323.png',
        farmerId: 'f2',
        pickupLocation: 'Farm L, Vijayapura',
        totalQuantity: 500,
      ),

      // --- Bigger catalog (all categories) ---
      // Fruits
      Product(
        id: 'p15',
        name: 'Pomegranate',
        category: 'Fruits',
        pricePerKg: 160,
        imageUrl: 'assets/images/Pomegranate_fruit_isolated_transparent_1773121964061.png',
        farmerId: 'f3',
        pickupLocation: 'Farm M, Koppal',
        totalQuantity: 220,
      ),
      Product(
        id: 'p16',
        name: 'Guava',
        category: 'Fruits',
        pricePerKg: 75,
        imageUrl: 'assets/images/Guava_fruit_isolated_transparent_1773121965264.png',
        farmerId: 'f1',
        pickupLocation: 'Farm A, Hubli',
        totalQuantity: 420,
      ),
      Product(
        id: 'p17',
        name: 'Papaya',
        category: 'Fruits',
        pricePerKg: 68,
        imageUrl: 'assets/images/Papaya_fruit_isolated_transparent_1773121966133.png',
        farmerId: 'f4',
        pickupLocation: 'Farm I, Bagalkot',
        totalQuantity: 260,
      ),
      Product(
        id: 'p18',
        name: 'Grapes',
        category: 'Fruits',
        pricePerKg: 110,
        imageUrl: 'assets/images/Grapes_fruit_isolated_transparent_1773121967386.png',
        farmerId: 'f5',
        pickupLocation: 'Farm J, Raichur',
        totalQuantity: 180,
      ),
      Product(
        id: 'p19',
        name: 'Oranges',
        category: 'Fruits',
        pricePerKg: 95,
        imageUrl: 'assets/images/Orange_fruit_isolated_transparent_1773121968212.png',
        farmerId: 'f2',
        pickupLocation: 'Farm F, Belagavi',
        totalQuantity: 300,
      ),
      Product(
        id: 'p20',
        name: 'Watermelon',
        category: 'Fruits',
        pricePerKg: 32,
        imageUrl: 'assets/images/Watermelon_fruit_slice_isolated_transparent_1773121971305.png',
        farmerId: 'f3',
        pickupLocation: 'Farm H, Davanagere',
        totalQuantity: 700,
      ),

      // Vegetables
      Product(
        id: 'p21',
        name: 'Onions',
        category: 'Vegetables',
        pricePerKg: 42,
        imageUrl: 'assets/images/Onion_vegetable_isolated_transparent_1773121972575.png',
        farmerId: 'f2',
        pickupLocation: 'Farm L, Vijayapura',
        totalQuantity: 1100,
      ),
      Product(
        id: 'p22',
        name: 'Cucumber',
        category: 'Vegetables',
        pricePerKg: 38,
        imageUrl: 'assets/images/Cucumber_vegetable_isolated_transparent_1773121973601.png',
        farmerId: 'f1',
        pickupLocation: 'Farm B, Dharwad',
        totalQuantity: 520,
      ),
      Product(
        id: 'p23',
        name: 'Cauliflower',
        category: 'Vegetables',
        pricePerKg: 58,
        imageUrl: 'assets/images/Cauliflower_vegetable_isolated_transparent_1773121974839.png',
        farmerId: 'f4',
        pickupLocation: 'Farm E, Mysore',
        totalQuantity: 210,
      ),
      Product(
        id: 'p24',
        name: 'Spinach',
        category: 'Vegetables',
        pricePerKg: 30,
        imageUrl: 'assets/images/Spinach_leaves_vegetable_isolated_transparent_1773121975880.png',
        farmerId: 'f3',
        pickupLocation: 'Farm C, Gadag',
        totalQuantity: 190,
      ),
      Product(
        id: 'p25',
        name: 'Green Beans',
        category: 'Vegetables',
        pricePerKg: 65,
        imageUrl: 'assets/images/Green_beans_vegetable_isolated_transparent_1773121977166.png',
        farmerId: 'f5',
        pickupLocation: 'Farm G, Karwar',
        totalQuantity: 260,
      ),
      Product(
        id: 'p26',
        name: 'Capsicum (Bell Pepper)',
        category: 'Vegetables',
        pricePerKg: 88,
        imageUrl: 'assets/images/Bell_pepper_capsicum_vegetable_isolated_transparent_1773121978486.png',
        farmerId: 'f1',
        pickupLocation: 'Farm A, Hubli',
        totalQuantity: 240,
      ),

      // Grains / legumes
      Product(
        id: 'p27',
        name: 'Millets (Ragi)',
        category: 'Grains',
        pricePerKg: 52,
        imageUrl: 'assets/images/Millet_grains__ragi__isolated_transparent_1773121980698.jpg',
        farmerId: 'f2',
        pickupLocation: 'Farm F, Belagavi',
        totalQuantity: 1600,
      ),
      Product(
        id: 'p28',
        name: 'Oats',
        category: 'Grains',
        pricePerKg: 92,
        imageUrl: 'assets/images/Oats_grains_isolated_transparent_1773121983552.png',
        farmerId: 'f4',
        pickupLocation: 'Farm I, Bagalkot',
        totalQuantity: 900,
      ),
      Product(
        id: 'p29',
        name: 'Sorghum (Jowar)',
        category: 'Grains',
        pricePerKg: 44,
        imageUrl: 'assets/images/Sorghum_grains__jowar__isolated_transparent_1773121985398.jpg',
        farmerId: 'f3',
        pickupLocation: 'Farm M, Koppal',
        totalQuantity: 1800,
      ),
      Product(
        id: 'p30',
        name: 'Chickpeas (Chana)',
        category: 'Grains',
        pricePerKg: 78,
        imageUrl: 'assets/images/Chickpeas__chana__grains_legumes_isolated_transparent_1773121987051.jpg',
        farmerId: 'f5',
        pickupLocation: 'Farm J, Raichur',
        totalQuantity: 1400,
      ),
      Product(
        id: 'p31',
        name: 'Lentils (Masoor Dal)',
        category: 'Grains',
        pricePerKg: 86,
        imageUrl: 'assets/images/Lentils__masoor_dal__grains_legumes_isolated_transparent_1773121989180.jpg',
        farmerId: 'f1',
        pickupLocation: 'Farm B, Dharwad',
        totalQuantity: 1250,
      ),
      Product(
        id: 'p32',
        name: 'Barley',
        category: 'Grains',
        pricePerKg: 48,
        imageUrl: 'assets/images/Barley_grain_bowl_isolated_transparent_1773122003954.png',
        farmerId: 'f2',
        pickupLocation: 'Farm L, Vijayapura',
        totalQuantity: 1350,
      ),

      // Nuts / seeds
      Product(
        id: 'p33',
        name: 'Walnuts',
        category: 'Nuts',
        pricePerKg: 980,
        imageUrl: 'assets/images/Walnuts_nuts_isolated_transparent_1773121990419.png',
        farmerId: 'f4',
        pickupLocation: 'Farm D, Badami',
        totalQuantity: 65,
        isRare: true,
      ),
      Product(
        id: 'p34',
        name: 'Pistachios',
        category: 'Nuts',
        pricePerKg: 1200,
        imageUrl: 'assets/images/Pistachios_nuts_isolated_transparent_1773121991273.png',
        farmerId: 'f3',
        pickupLocation: 'Farm K, Udupi',
        totalQuantity: 40,
        isRare: true,
      ),
      Product(
        id: 'p35',
        name: 'Hazelnuts',
        category: 'Nuts',
        pricePerKg: 1350,
        imageUrl: 'assets/images/Hazelnut_nuts_pile_isolated_transparent_1773122005156.png',
        farmerId: 'f5',
        pickupLocation: 'Farm G, Karwar',
        totalQuantity: 35,
        isRare: true,
      ),
      Product(
        id: 'p36',
        name: 'Macadamia Nuts',
        category: 'Nuts',
        pricePerKg: 1600,
        imageUrl: 'assets/images/Macadamia_nuts_isolated_transparent_1773122005960.png',
        farmerId: 'f4',
        pickupLocation: 'Farm D, Badami',
        totalQuantity: 28,
        isRare: true,
      ),
      Product(
        id: 'p37',
        name: 'Sunflower Seeds',
        category: 'Nuts',
        pricePerKg: 220,
        imageUrl: 'assets/images/Sunflower_seeds_nuts_seeds_isolated_transparent_1773121993497.png',
        farmerId: 'f2',
        pickupLocation: 'Farm F, Belagavi',
        totalQuantity: 480,
      ),
      Product(
        id: 'p38',
        name: 'Pumpkin Seeds',
        category: 'Nuts',
        pricePerKg: 260,
        imageUrl: 'assets/images/Pumpkin_seeds_pile_isolated_transparent_1773122007226.png',
        farmerId: 'f1',
        pickupLocation: 'Farm A, Hubli',
        totalQuantity: 420,
      ),
    ];

    _sellingHistory = [
      SellingRecord(
        id: 's1',
        farmerId: _currentUser?.id ?? 'temp',
        product: _products[0],
        quantitySold: 50,
        earnings: 50 * 120,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: SellingStatus.completed,
      ),
    ];
  }

  // --- Farmer Selling ---
  List<SellingRecord> _sellingHistory = [];
  List<SellingRecord> get sellingHistory => _sellingHistory;

  void sellProduct({
    required String name,
    required String category,
    required double pricePerKg,
    required double quantity,
    required String pickupLocation,
  }) {
    if (_currentUser == null) return;
    
    // Create new product if needed or update existing (simplified to always create new for now)
    final product = Product(
      id: _uuid.v4(),
      name: name,
      category: category,
      pricePerKg: pricePerKg,
      imageUrl: '', // default empty, use a placeholder in UI
      farmerId: _currentUser!.id,
      pickupLocation: pickupLocation,
      totalQuantity: quantity,
    );
    _products.add(product);

    final record = SellingRecord(
      id: _uuid.v4(),
      farmerId: _currentUser!.id,
      product: product,
      quantitySold: quantity,
      earnings: quantity * pricePerKg,
      date: DateTime.now(),
      status: SellingStatus.pendingVerification, // Mock gov verification
    );
    _sellingHistory.add(record);
    notifyListeners();
  }

  // --- Customer Cart ---
  List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  String addToCart(Product product, int quantity) {
    if (quantity > 50) return 'Maximum limit is 50kg per product.';
    if (product.isRare && quantity > product.totalQuantity) return 'Out of Stock for requested quantity.';

    int existingIndex = _cart.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      if (_cart[existingIndex].quantity + quantity > 50) return 'Total cart limit is 50kg for this product.';
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
    return 'Success';
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get cartTotal {
    return _cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // --- Customer Orders ---
  List<AppOrder> _orders = [];
  List<AppOrder> get orders => _orders;

  void placeOrder(String deliveryLocation) {
    if (_currentUser == null || _cart.isEmpty) return;

    final newOrder = AppOrder(
      id: _uuid.v4(),
      customerId: _currentUser!.id,
      items: List.from(_cart),
      totalPrice: cartTotal,
      date: DateTime.now(),
      status: OrderStatus.processing,
      deliveryLocation: deliveryLocation,
    );

    // Update product quantities
    for (var item in _cart) {
      final pIndex = _products.indexWhere((p) => p.id == item.product.id);
      if (pIndex >= 0) {
        _products[pIndex].totalQuantity -= item.quantity;
      }
    }

    _orders.insert(0, newOrder);
    _cart.clear();
    notifyListeners();
  }

  // --- Chat / AI ---
  List<ChatMessage> _farmerChat = [];
  List<ChatMessage> get farmerChat => _farmerChat;
  
  List<ChatMessage> _customerChat = [];
  List<ChatMessage> get customerChat => _customerChat;

  void addMessage(String text, bool isUser, UserRole role) {
    final msg = ChatMessage(
      id: _uuid.v4(),
      text: text,
      isUser: isUser,
      timestamp: DateTime.now(),
    );
    if (role == UserRole.farmer) {
      _farmerChat.add(msg);
    } else {
      _customerChat.add(msg);
    }
    notifyListeners();
  }
}
