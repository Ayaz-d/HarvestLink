import 'package:uuid/uuid.dart';

enum UserRole { farmer, customer }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class Product {
  final String id;
  final String name;
  final String category; // Fruits, Vegetables, Grains, Nuts
  final double pricePerKg;
  final String imageUrl;
  final bool isRare;
  final String farmerId;
  final String pickupLocation;
  double totalQuantity;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerKg,
    required this.imageUrl,
    this.isRare = false,
    required this.farmerId,
    required this.pickupLocation,
    required this.totalQuantity,
  });
}

class CartItem {
  final Product product;
  int quantity; // Using int for kg simplicity

  CartItem({required this.product, required this.quantity});
  
  double get totalPrice => product.pricePerKg * quantity;
}

enum OrderStatus { pending, processing, shipped, delivered }

class AppOrder {
  final String id;
  final String customerId;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime date;
  final OrderStatus status;
  final String deliveryLocation;

  AppOrder({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalPrice,
    required this.date,
    required this.status,
    required this.deliveryLocation,
  });
}

enum SellingStatus { pendingVerification, accepted, completed }

class SellingRecord {
  final String id;
  final String farmerId;
  final Product product;
  final double quantitySold;
  final double earnings;
  final DateTime date;
  final SellingStatus status;

  SellingRecord({
    required this.id,
    required this.farmerId,
    required this.product,
    required this.quantitySold,
    required this.earnings,
    required this.date,
    required this.status,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
