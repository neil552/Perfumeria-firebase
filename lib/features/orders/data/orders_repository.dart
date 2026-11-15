import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Copia de una línea del carrito guardada en el resumen de un pedido.
class OrderItemModel {
  const OrderItemModel({
    required this.productName,
    required this.image,
    required this.quantity,
    required this.unitPrice,
    this.wrapping,
    this.card,
    this.dedication,
    this.variant,
  });

  final String productName;
  final String image;
  final int quantity;
  final double unitPrice;
  final String? wrapping;
  final String? card;
  final String? dedication;
  final String? variant;

  /// Total de la línea al precio unitario guardado en el momento de compra.
  double get total => unitPrice * quantity;

  /// Texto compacto con las opciones elegidas para mostrar en el historial.
  String get description => [
    wrapping,
    card,
    variant,
    if (dedication != null && dedication!.isNotEmpty) 'Dedicatoria incluida',
  ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

  /// Convierte la línea en un mapa compatible con Cloud Firestore.
  Map<String, dynamic> toMap() => {
    'productName': productName,
    'image': image,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'wrapping': wrapping,
    'card': card,
    'dedication': dedication,
    'variant': variant,
  };

  /// Reconstruye una línea usando la copia de producto guardada en el pedido.
  factory OrderItemModel.fromMap(Map<String, dynamic> data) {
    return OrderItemModel(
      productName: data['productName'] as String,
      image: data['image'] as String,
      quantity: data['quantity'] as int,
      unitPrice: (data['unitPrice'] as num).toDouble(),
      wrapping: data['wrapping'] as String?,
      card: data['card'] as String?,
      dedication: data['dedication'] as String?,
      variant: data['variant'] as String?,
    );
  }
}

/// Modelo inmutable de un pedido guardado en Firestore.
class OrderModel {
  const OrderModel({
    required this.code,
    required this.date,
    required this.total,
    required this.status,
    required this.image,
    this.id,
    this.active = false,
    this.items = const [],
    this.deliveryMode = 'Delivery',
    this.deliveryDate = '',
    this.deliveryTime = '',
    this.customerName = '',
    this.phone = '',
    this.address = '',
    this.reference = '',
  });

  /// Identificador del documento Firestore; es nulo antes de guardar el pedido.
  final String? id;
  final String code;
  final String date;
  final double total;
  final String status;
  final String image;
  final bool active;
  final List<OrderItemModel> items;
  final String deliveryMode;
  final String deliveryDate;
  final String deliveryTime;
  final String customerName;
  final String phone;
  final String address;
  final String reference;

  /// Número total de unidades de todas las líneas del pedido.
  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  /// Convierte los campos de negocio a un mapa independiente de Firebase.
  Map<String, dynamic> toMap() => {
    'code': code,
    'date': date,
    'total': total,
    'status': status,
    'active': active,
    'image': image,
    'items': items.map((item) => item.toMap()).toList(),
    'deliveryMode': deliveryMode,
    'deliveryDate': deliveryDate,
    'deliveryTime': deliveryTime,
    'customerName': customerName,
    'phone': phone,
    'address': address,
    'reference': reference,
  };

  /// Añade el propietario y la marca de tiempo del servidor al documento.
  Map<String, dynamic> toFirestore({required String userId}) => {
    'userId': userId,
    'createdAt': FieldValue.serverTimestamp(),
    ...toMap(),
  };

  /// Construye el modelo a partir de un documento de la subcolección del usuario.
  factory OrderModel.fromMap(String id, Map<String, dynamic> data) {
    final rawItems = data['items'] as List<dynamic>;
    return OrderModel(
      id: id,
      code: data['code'] as String,
      date: data['date'] as String,
      total: (data['total'] as num).toDouble(),
      status: data['status'] as String,
      image: data['image'] as String,
      active: data['active'] as bool,
      items: rawItems
          .map(
            (item) =>
                OrderItemModel.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      deliveryMode: data['deliveryMode'] as String,
      deliveryDate: data['deliveryDate'] as String,
      deliveryTime: data['deliveryTime'] as String,
      customerName: data['customerName'] as String,
      phone: data['phone'] as String,
      address: data['address'] as String,
      reference: data['reference'] as String,
    );
  }

  /// Devuelve una copia con el ID creado por Firestore tras guardar.
  OrderModel withId(String documentId) => OrderModel(
    id: documentId,
    code: code,
    date: date,
    total: total,
    status: status,
    image: image,
    active: active,
    items: items,
    deliveryMode: deliveryMode,
    deliveryDate: deliveryDate,
    deliveryTime: deliveryTime,
    customerName: customerName,
    phone: phone,
    address: address,
    reference: reference,
  );
}

/// Guarda y consulta pedidos dentro de la cuenta Firebase activa.
///
/// Cada usuario utiliza exclusivamente `users/{uid}/orders/{orderId}`. El
/// historial ya no depende de listas de demostración en memoria.
class OrdersRepository {
  OrdersRepository._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Emite el historial de la sesión actual, ordenado del más reciente al antiguo.
  ///
  /// Una sesión de invitado no tiene pedidos y recibe una lista vacía.
  static Stream<List<OrderModel>> watchForCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(const <OrderModel>[]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) => OrderModel.fromMap(document.id, document.data()),
              )
              .toList(),
        );
  }

  /// Persiste el pedido bajo la cuenta autenticada y devuelve su ID de Firestore.
  static Future<OrderModel> createForCurrentUser(OrderModel order) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'unauthenticated');
    }

    final document = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc();
    await document.set(order.toFirestore(userId: user.uid));
    return order.withId(document.id);
  }
}
