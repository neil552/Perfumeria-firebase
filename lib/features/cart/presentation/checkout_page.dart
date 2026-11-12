import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/action_footer.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/labeled_field.dart';
import '../../auth/data/auth_error_message.dart';
import '../../auth/data/auth_repository.dart';
import '../data/cart_repository.dart';
import '../../orders/data/orders_repository.dart';

/// Pantalla de entrega y confirmación del pedido.
///
/// Equivale al componente `Checkout` del proyecto React original.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

/// Gestiona los datos de entrega y el estado de confirmación del checkout.
class _CheckoutPageState extends State<CheckoutPage> {
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _referenceController = TextEditingController();
  String _delivery = 'Delivery';
  String _time = '10:00 - 13:00';
  late final List<DateTime> _dates;
  late DateTime _selectedDate;
  bool _isSubmitting = false;

  static const List<String> _times = [
    '10:00 - 13:00',
    '14:00 - 17:00',
    '18:00 - 20:00',
  ];
  static const List<String> _weekdays = [
    'Dom.',
    'Lun.',
    'Mar.',
    'Mié.',
    'Jue.',
    'Vie.',
    'Sáb.',
  ];
  static const List<String> _months = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  @override
  void initState() {
    super.initState();
    _dates = List.generate(
      3,
      (index) => DateTime.now().add(Duration(days: index + 1)),
    );
    _selectedDate = _dates.first;
    _customerNameController.text =
        AuthRepository.currentUser?.displayName ?? '';
    _loadSavedPhone();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPhone() async {
    if (AuthRepository.currentUser == null) return;
    try {
      final profile = await AuthRepository.getProfile();
      if (mounted && _phoneController.text.isEmpty) {
        _phoneController.text = profile['phone'] as String;
      }
    } on FirebaseException catch (error) {
      if (mounted) _showError(authErrorMessage(error));
    }
  }

  /// Valida los datos, crea un pedido demostrativo y vacía el carrito.
  ///
  /// El pedido se conserva en memoria para el historial de esta ejecución; el
  /// flujo no procesa pagos ni persiste pedidos en Firestore.
  Future<void> _confirmOrder() async {
    final cart = CartRepository.instance;
    if (cart.isEmpty) {
      _showError('Agrega al menos un producto antes de confirmar.');
      return;
    }
    if (_customerNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        (_delivery == 'Delivery' && _addressController.text.trim().isEmpty)) {
      _showError('Completa tu nombre, celular y dirección de entrega.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final now = DateTime.now();
      final code =
          'RE-${(now.year % 100).toString().padLeft(2, '0')}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}-'
          '${(now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';
      final order = OrderModel(
        code: code,
        date: '${now.day} ${_months[now.month - 1]} ${now.year}',
        total:
            cart.total +
            (_delivery == 'Delivery' ? AppConstants.deliveryFee : 0),
        status: 'En preparación',
        image: cart.items.value.first.product.image,
        active: true,
        items: cart.items.value
            .map(
              (item) => OrderItemModel(
                productName: item.product.name,
                image: item.product.image,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
                wrapping: item.wrapping,
                card: item.card,
                dedication: item.dedication,
                variant: item.variant,
              ),
            )
            .toList(),
        deliveryMode: _delivery,
        deliveryDate: _formatDate(_selectedDate),
        deliveryTime: _time,
        customerName: _customerNameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _delivery == 'Delivery'
            ? _addressController.text.trim()
            : 'Tienda Central · Av. Principal 120',
        reference: _referenceController.text.trim(),
      );

      OrdersRepository.add(order);
      cart.clear();
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.success, arguments: order);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatDate(DateTime date) =>
      '${_weekdays[date.weekday % 7]} ${date.day} ${_months[date.month - 1]}';

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFB13B50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = CartRepository.instance.items.value;
    final productsTotal = items.fold<double>(
      0,
      (sum, item) => sum + item.lineTotal,
    );
    final isDelivery = _delivery == 'Delivery';
    final deliveryFee = isDelivery ? AppConstants.deliveryFee : 0.0;
    final total = productsTotal + deliveryFee;

    return Scaffold(
      bottomNavigationBar: ActionFooter(
        note: 'Al confirmar, registraremos tu pedido demostrativo.',
        child: PrimaryButton(
          label: _isSubmitting ? 'Registrando pedido...' : 'Confirmar pedido',
          trailing: const AppIcon('chevron', size: 18),
          onPressed: _isSubmitting ? null : _confirmOrder,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: 'Entrega y confirmación',
                onBack: () => Navigator.pop(context),
              ),
              _buildProgress(),
              _buildContactCard(),
              const SizedBox(height: 12),
              _buildDeliveryCard(),
              const SizedBox(height: 12),
              _buildScheduleCard(),
              const SizedBox(height: 12),
              _buildReviewCard(items, isDelivery, deliveryFee, total),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _progressStep('done', 'Carrito', done: true, active: true),
          _progressBar(),
          _progressStep('2', 'Entrega', active: true),
          _progressBar(),
          _progressStep('3', 'Confirmación'),
        ],
      ),
    );
  }

  Widget _progressStep(
    String marker,
    String label, {
    bool done = false,
    bool active = false,
  }) {
    final color = (done || active) ? AppTheme.wine : const Color(0xFFAA989F);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: (done || active) ? AppTheme.wine : const Color(0xFFE9DDDA),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: done
              ? const AppIcon('check', size: 12, color: Colors.white)
              : Text(
                  marker,
                  style: AppTheme.poppins(
                    size: 10,
                    color: (done || active) ? Colors.white : color,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.poppins(size: 7, color: color)),
      ],
    );
  }

  Widget _progressBar() {
    return Container(
      width: 50,
      height: 1,
      margin: const EdgeInsets.only(bottom: 13),
      color: const Color(0xFFDFCFCA),
    );
  }

  Widget _buildContactCard() {
    return _CheckoutCard(
      number: '1',
      title: 'Datos de contacto',
      subtitle: 'Te avisaremos sobre tu pedido',
      children: [
        LabeledField(
          label: 'Nombre completo',
          controller: _customerNameController,
        ),
        LabeledField(
          label: 'Número de celular',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildDeliveryCard() {
    final isDelivery = _delivery == 'Delivery';
    return _CheckoutCard(
      number: '2',
      title: 'Modalidad de entrega',
      subtitle: 'Elige cómo recibir tu detalle',
      children: [
        Row(
          children: [
            Expanded(
              child: _deliveryOption(
                type: 'Delivery',
                title: 'Delivery',
                subtitle: 'Desde S/ 8.00',
                icon: 'pin',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _deliveryOption(
                type: 'Recojo',
                title: 'Recojo en tienda',
                subtitle: 'Sin costo',
                icon: 'bag',
              ),
            ),
          ],
        ),
        if (isDelivery)
          LabeledField(
            label: 'Dirección de entrega',
            controller: _addressController,
            hint: 'Ingresa calle, número y distrito',
          )
        else
          const LabeledField(
            label: 'Punto de recojo',
            initialValue: 'Tienda Central · Av. Principal 120',
            readOnly: true,
          ),
        if (isDelivery)
          LabeledField(
            label: 'Referencia',
            controller: _referenceController,
            hint: 'Ej. Frente al parque, puerta blanca',
          ),
      ],
    );
  }

  Widget _deliveryOption({
    required String type,
    required String title,
    required String subtitle,
    required String icon,
  }) {
    final active = _delivery == type;
    return GestureDetector(
      onTap: () => setState(() => _delivery = type),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFDF8FA) : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: active ? AppTheme.wine : AppTheme.line,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFF2E5EA),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: AppIcon(icon, size: 18, color: AppTheme.wine),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTheme.poppins(size: 8, weight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.poppins(size: 6, color: AppTheme.muted),
                  ),
                ],
              ),
            ),
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCEBFC4)),
              ),
              alignment: Alignment.center,
              child: active
                  ? Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppTheme.wine,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return _CheckoutCard(
      number: '3',
      title: 'Fecha y horario',
      subtitle: 'Agenda el momento perfecto',
      children: [
        Row(
          children: [
            for (final date in _dates) ...[
              Expanded(child: _dateOption(date)),
              if (date != _dates.last) const SizedBox(width: 8),
            ],
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: AppIcon('clock', size: 18, color: AppTheme.wine),
              ),
              for (final time in _times) ...[
                GestureDetector(
                  onTap: () => setState(() => _time = time),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _time == time ? AppTheme.wine : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _time == time ? AppTheme.wine : AppTheme.line,
                      ),
                    ),
                    child: Text(
                      time,
                      style: AppTheme.poppins(
                        size: 7,
                        color: _time == time ? Colors.white : AppTheme.plum,
                      ),
                    ),
                  ),
                ),
                if (time != _times.last) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _dateOption(DateTime date) {
    final active = _selectedDate == date;
    return GestureDetector(
      onTap: () => setState(() => _selectedDate = date),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppTheme.wine : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? AppTheme.wine : AppTheme.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weekdays[date.weekday % 7],
              style: AppTheme.poppins(
                size: 7,
                color: active ? Colors.white : AppTheme.plum,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date.day.toString(),
                  style: AppTheme.poppins(
                    size: 18,
                    weight: FontWeight.w600,
                    color: active ? Colors.white : AppTheme.plum,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    _months[date.month - 1],
                    style: AppTheme.poppins(
                      size: 8,
                      color: active ? Colors.white : AppTheme.plum,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    List<CartItem> items,
    bool isDelivery,
    double deliveryFee,
    double total,
  ) {
    return _CheckoutCard(
      number: '4',
      title: 'Tu pedido',
      subtitle: 'Revisa antes de confirmar',
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: AppImage(url: item.product.image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: AppTheme.poppins(
                          size: 8,
                          weight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Cantidad: ${item.quantity}'
                        '${item.variant != null ? ' · ${item.variant}' : ''}'
                        '${item.wrapping != null ? ' · ${item.wrapping}' : ''}',
                        style: AppTheme.poppins(size: 6, color: AppTheme.muted),
                      ),
                    ],
                  ),
                ),
                Text(
                  soles(item.lineTotal),
                  style: AppTheme.poppins(size: 8, weight: FontWeight.w600),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.only(top: 11),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.line)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entrega ($_delivery)',
                style: AppTheme.poppins(size: 9, color: AppTheme.muted),
              ),
              Text(
                isDelivery ? soles(deliveryFee) : 'Gratis',
                style: AppTheme.poppins(size: 9, weight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 11),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.line)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.poppins(size: 13, weight: FontWeight.w600),
              ),
              Text(
                soles(total),
                style: AppTheme.poppins(
                  size: 15,
                  weight: FontWeight.w600,
                  color: AppTheme.wine,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tarjeta numerada usada en la pantalla de checkout.
class _CheckoutCard extends StatelessWidget {
  const _CheckoutCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String number;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.plum.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppTheme.wine,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: AppTheme.poppins(size: 10, color: Colors.white),
                ),
              ),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTheme.poppins(size: 14, weight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.poppins(size: 8, color: AppTheme.muted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 13),
          for (final child in children) ...[
            child,
            if (child != children.last) const SizedBox(height: 13),
          ],
        ],
      ),
    );
  }
}
