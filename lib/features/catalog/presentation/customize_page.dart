import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/action_footer.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/custom_button.dart';
import '../../cart/data/cart_repository.dart';
import '../data/product_model.dart';

/// Pantalla de personalización de un regalo.
///
/// Equivale al componente `Customize` del proyecto React original.
class CustomizePage extends StatefulWidget {
  const CustomizePage({super.key, required this.product});

  final Product product;

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

/// Conserva las opciones de empaque y tarjeta elegidas para el regalo.
class _CustomizePageState extends State<CustomizePage> {
  static const List<_WrappingOption> _wrappings = [
    _WrappingOption('Vino & dorado', Color(0xFF8E4569), '+ S/ 12.00', 12),
    _WrappingOption('Rosa clásico', Color(0xFFD9A6B9), '+ S/ 8.00', 8),
    _WrappingOption('Natural', Color(0xFFD6B77B), 'Sin costo', 0),
  ];

  static const List<_CardOption> _cards = [
    _CardOption('Floral', Color(0xFFF1DFE7), AppTheme.wine, 'heart'),
    _CardOption('Minimalista', Color(0xFFF4EEE5), Color(0xFF9E814E), 'sparkle'),
    _CardOption('Celebración', Color(0xFFEAD9DF), AppTheme.wine, 'gift'),
  ];

  String _wrapping = 'Vino & dorado';
  String _card = 'Floral';
  final _dedicationController = TextEditingController(
    text:
        'Feliz cumpleaños, que todos tus sueños se hagan realidad. Con cariño.',
  );

  double get _extra => _wrappings.firstWhere((w) => w.name == _wrapping).extra;

  @override
  void initState() {
    super.initState();
    _dedicationController.addListener(_onDedicationChanged);
  }

  void _onDedicationChanged() => setState(() {});

  @override
  void dispose() {
    _dedicationController.removeListener(_onDedicationChanged);
    _dedicationController.dispose();
    super.dispose();
  }

  void _addToCart() {
    CartRepository.instance.addCustom(
      CartItem(
        product: widget.product,
        quantity: 1,
        wrapping: _wrapping,
        card: _card,
        dedication: _dedicationController.text,
        extra: _extra,
      ),
    );
    Navigator.pushReplacementNamed(context, AppRoutes.cart);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: 'Personaliza tu regalo',
                onBack: () => Navigator.pop(context),
              ),
              _buildPreview(product),
              _buildWrappingStep(),
              _buildCardStep(),
              _buildDedicationStep(),
              _buildSummary(product),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ActionFooter(
        child: PrimaryButton(
          label: 'Agregar al carrito · ${soles(product.price + _extra)}',
          iconName: 'bag',
          onPressed: _addToCart,
        ),
      ),
    );
  }

  Widget _buildPreview(Product product) {
    final dedication = _dedicationController.text;
    final snippet = dedication.length > 42
        ? '${dedication.substring(0, 42)}…'
        : dedication;
    final pink = _wrapping.contains('Rosa');
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.plum.withValues(alpha: 0.11),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: const Color(0xFFEEEEEE),
              child: AppImage(url: product.image, fit: BoxFit.cover),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x9935212D)],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 26,
                color:
                    (pink ? const Color(0xFFD9A6B9) : const Color(0xFF8E4569))
                        .withValues(alpha: 0.8),
              ),
            ),
          ),
          Positioned(
            bottom: 13,
            left: 14,
            right: 14,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Para alguien especial',
                    style: AppTheme.playfair(
                      size: 13,
                      weight: FontWeight.w500,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    snippet,
                    textAlign: TextAlign.right,
                    style: AppTheme.poppins(size: 7, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFDF8).withValues(alpha: 0.91),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppIcon('sparkle', size: 14, color: AppTheme.wine),
                  const SizedBox(width: 4),
                  Text(
                    'Vista previa',
                    style: AppTheme.poppins(
                      size: 8,
                      weight: FontWeight.w600,
                      color: AppTheme.wine,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String number, String title, String subtitle) {
    return Row(
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
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTheme.poppins(size: 17, weight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTheme.poppins(size: 8, color: AppTheme.muted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWrappingStep() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            '1',
            'Elige el empaque',
            'La primera impresión también emociona',
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              for (final option in _wrappings) ...[
                Expanded(child: _wrappingOption(option)),
                if (option != _wrappings.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _wrappingOption(_WrappingOption option) {
    final active = _wrapping == option.name;
    return GestureDetector(
      onTap: () => setState(() => _wrapping = option.name),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFDF7F9) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? AppTheme.wine : AppTheme.line,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 53,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: option.color,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: const Alignment(0, 0),
                    child: Container(
                      width: 10,
                      color: const Color(0xFFE0BD72).withValues(alpha: 0.67),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              option.name,
              style: AppTheme.poppins(size: 8, weight: FontWeight.w500),
            ),
            Text(
              option.priceLabel,
              style: AppTheme.poppins(size: 7, color: AppTheme.muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStep() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            '2',
            'Selecciona una tarjeta',
            'Un detalle que guarda tus palabras',
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              for (final option in _cards) ...[
                Expanded(child: _cardOption(option)),
                if (option != _cards.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardOption(_CardOption option) {
    final active = _card == option.name;
    return GestureDetector(
      onTap: () => setState(() => _card = option.name),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: active ? AppTheme.wine : AppTheme.line,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 65,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: option.background,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.white),
              ),
              alignment: Alignment.center,
              child: AppIcon(option.icon, size: 18, color: option.foreground),
            ),
            Text(option.name, style: AppTheme.poppins(size: 8)),
          ],
        ),
      ),
    );
  }

  Widget _buildDedicationStep() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            '3',
            'Escribe tu dedicatoria',
            'Haz que tus palabras sean inolvidables',
          ),
          const SizedBox(height: 13),
          Stack(
            children: [
              TextField(
                controller: _dedicationController,
                maxLength: 160,
                maxLines: 4,
                style: AppTheme.playfair(
                  size: 12,
                  weight: FontWeight.w500,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.pink),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 11,
                child: Text(
                  '${_dedicationController.text.length}/160',
                  style: AppTheme.poppins(size: 8, color: AppTheme.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(Product product) {
    return Container(
      margin: const EdgeInsets.only(top: 28, bottom: 5),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow('Producto', product.name, soles(product.price)),
          const SizedBox(height: 11),
          _summaryRow(
            'Personalización',
            '$_wrapping · Tarjeta $_card',
            _extra > 0 ? soles(_extra) : 'Gratis',
          ),
          const Divider(height: 24, color: AppTheme.line),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.poppins(size: 13, weight: FontWeight.w600),
              ),
              Text(
                soles(product.price + _extra),
                style: AppTheme.poppins(
                  size: 15,
                  weight: FontWeight.w600,
                  color: AppTheme.wine,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.poppins(size: 8, color: AppTheme.muted)),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: AppTheme.poppins(size: 9, weight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            Text(amount, style: AppTheme.poppins(size: 9)),
          ],
        ),
      ],
    );
  }
}

/// Opción de empaque de la personalización.
class _WrappingOption {
  const _WrappingOption(this.name, this.color, this.priceLabel, this.extra);

  final String name;
  final Color color;
  final String priceLabel;
  final double extra;
}

/// Opción de tarjeta de la personalización.
class _CardOption {
  const _CardOption(this.name, this.background, this.foreground, this.icon);

  final String name;
  final Color background;
  final Color foreground;
  final String icon;
}
