import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../cart/data/cart_repository.dart';
import '../data/catalog_repository.dart';
import '../data/product_model.dart';
import 'product_detail_page.dart';
import 'widgets/product_card.dart';

/// Pantalla del catálogo ("Explorar").
///
/// Equivale al componente `Catalog` del proyecto React original.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

/// Criterios disponibles para ordenar los resultados del catálogo.
enum _CatalogSortOrder { relevant, priceAscending, priceDescending, name }

/// Mantiene los filtros y la consulta activa del catálogo.
class _CatalogPageState extends State<CatalogPage> {
  final _searchController = TextEditingController();

  String _tab = 'Regalos';
  bool _filterOpen = false;
  String _activeFilter = 'Todos';
  String _selectedPriceRange = 'Todos';
  _CatalogSortOrder _sortOrder = _CatalogSortOrder.relevant;

  static const List<String> _giftCategories = [
    'Todos',
    'Cajas sorpresa',
    'Peluches',
    'Flores',
    'Accesorios',
  ];
  static const List<String> _fragranceCategories = [
    'Todos',
    'Perfumes',
    'Colonias',
    'Sets',
    'Mujer',
    'Hombre',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _go(String route) => Navigator.pushReplacementNamed(context, route);

  void _open(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
    );
  }

  /// Aplica en un solo paso el rubro, texto, tipo, rango de precio y orden.
  List<Product> get _visible {
    final search = _searchController.text.trim().toLowerCase();
    final products = CatalogRepository.products.where((product) {
      final matchesTab = _tab == 'Perfumería'
          ? product.isFragrance
          : !product.isFragrance;
      final matchesSearch =
          product.name.toLowerCase().contains(search) ||
          product.category.toLowerCase().contains(search);
      final matchesFilter = switch (_activeFilter) {
        'Todos' => true,
        'Promoción' => product.oldPrice != null,
        'Perfumes' => product.isFragrance,
        _ => product.category.contains(_activeFilter),
      };
      final matchesPrice = switch (_selectedPriceRange) {
        'Hasta S/ 80' => product.price <= 80,
        'S/ 80–150' => product.price > 80 && product.price <= 150,
        'Más de S/ 150' => product.price > 150,
        _ => true,
      };
      return matchesTab && matchesSearch && matchesFilter && matchesPrice;
    }).toList();

    switch (_sortOrder) {
      case _CatalogSortOrder.relevant:
        break;
      case _CatalogSortOrder.priceAscending:
        products.sort((a, b) => a.price.compareTo(b.price));
      case _CatalogSortOrder.priceDescending:
        products.sort((a, b) => b.price.compareTo(a.price));
      case _CatalogSortOrder.name:
        products.sort((a, b) => a.name.compareTo(b.name));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        current: AppRoutes.catalog,
        onNavigate: _go,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<List<CartItem>>(
                valueListenable: CartRepository.instance.items,
                builder: (context, items, child) => AppHeader(
                  title: 'Explorar',
                  cartCount: CartRepository.instance.count,
                  onCart: () => Navigator.pushNamed(context, AppRoutes.cart),
                ),
              ),
              const SizedBox(height: 4),
              _buildSegmented(),
              const SizedBox(height: 14),
              _buildSearchRow(),
              if (_filterOpen) ...[
                const SizedBox(height: 10),
                _buildFilterPanel(),
              ],
              _buildCategoryChips(),
              _buildResultsLine(visible.length),
              if (visible.isEmpty) _buildEmptySearch() else _buildGrid(visible),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmented() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEE3E3),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          for (final item in const ['Regalos', 'Perfumería'])
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _tab = item;
                  _activeFilter = 'Todos';
                  _selectedPriceRange = 'Todos';
                }),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: _tab == item ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: _tab == item
                        ? [
                            BoxShadow(
                              color: AppTheme.plum.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item,
                    style: AppTheme.poppins(
                      size: 11,
                      weight: _tab == item ? FontWeight.w600 : FontWeight.w400,
                      color: _tab == item
                          ? AppTheme.wine
                          : const Color(0xFF8E7A82),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFEEE3DF)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const AppIcon('search', size: 19, color: Color(0xFFA18D95)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    style: AppTheme.poppins(size: 12, color: AppTheme.plum),
                    decoration: InputDecoration.collapsed(
                      hintText: '¿Qué estás buscando?',
                      hintStyle: AppTheme.poppins(
                        size: 12,
                        color: const Color(0xFFA18D95),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 9),
        GestureDetector(
          onTap: () => setState(() => _filterOpen = !_filterOpen),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _filterOpen ? AppTheme.wine : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _filterOpen ? AppTheme.wine : AppTheme.line,
              ),
            ),
            alignment: Alignment.center,
            child: AppIcon(
              'filter',
              size: 22,
              color: _filterOpen ? Colors.white : AppTheme.wine,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: AppTheme.plum.withValues(alpha: 0.09),
            blurRadius: 35,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtrar productos',
                style: AppTheme.poppins(size: 12, weight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => setState(() => _filterOpen = false),
                child: const AppIcon('close', size: 18, color: AppTheme.plum),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            'Precio',
            style: AppTheme.poppins(size: 9, color: AppTheme.muted),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final label in const [
                'Todos',
                'Hasta S/ 80',
                'S/ 80–150',
                'Más de S/ 150',
              ])
                _chip(
                  label,
                  active: _selectedPriceRange == label,
                  onTap: () => setState(() => _selectedPriceRange = label),
                ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            'Tipo de producto',
            style: AppTheme.poppins(size: 9, color: AppTheme.muted),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final label in const ['Todos', 'Perfumes', 'Promoción'])
                _chip(
                  label,
                  active: _activeFilter == label,
                  onTap: () => setState(() => _activeFilter = label),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () => setState(() => _filterOpen = false),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.wine,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Aplicar filtros',
                  style: AppTheme.poppins(
                    size: 14,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, {bool active = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppTheme.wine : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: active ? AppTheme.wine : AppTheme.line),
        ),
        child: Text(
          label,
          style: AppTheme.poppins(
            size: 9,
            color: active ? Colors.white : AppTheme.plum,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = _tab == 'Regalos'
        ? _giftCategories
        : _fragranceCategories;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final category in categories) ...[
              GestureDetector(
                onTap: () => setState(() => _activeFilter = category),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _activeFilter == category
                        ? AppTheme.wine
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _activeFilter == category
                          ? AppTheme.wine
                          : const Color(0xFFE6D9D4),
                    ),
                  ),
                  child: Text(
                    category,
                    style: AppTheme.poppins(
                      size: 9,
                      color: _activeFilter == category
                          ? Colors.white
                          : const Color(0xFF826F77),
                    ),
                  ),
                ),
              ),
              if (category != categories.last) const SizedBox(width: 7),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsLine(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$count',
                  style: AppTheme.poppins(
                    size: 9,
                    weight: FontWeight.w600,
                    color: AppTheme.plum,
                  ),
                ),
                TextSpan(
                  text: ' productos encontrados',
                  style: AppTheme.poppins(size: 9, color: AppTheme.muted),
                ),
              ],
            ),
          ),
          PopupMenuButton<_CatalogSortOrder>(
            tooltip: 'Ordenar productos',
            onSelected: (order) => setState(() => _sortOrder = order),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _CatalogSortOrder.relevant,
                child: Text('Más relevantes'),
              ),
              PopupMenuItem(
                value: _CatalogSortOrder.priceAscending,
                child: Text('Menor precio'),
              ),
              PopupMenuItem(
                value: _CatalogSortOrder.priceDescending,
                child: Text('Mayor precio'),
              ),
              PopupMenuItem(
                value: _CatalogSortOrder.name,
                child: Text('Nombre'),
              ),
            ],
            child: Row(
              children: [
                Text(switch (_sortOrder) {
                  _CatalogSortOrder.relevant => 'Más relevantes',
                  _CatalogSortOrder.priceAscending => 'Menor precio',
                  _CatalogSortOrder.priceDescending => 'Mayor precio',
                  _CatalogSortOrder.name => 'Nombre',
                }, style: AppTheme.poppins(size: 9, color: AppTheme.plum)),
                const SizedBox(width: 4),
                Text(
                  '⌄',
                  style: AppTheme.poppins(size: 9, color: AppTheme.plum),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Product> visible) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final product in visible)
              SizedBox(
                width: itemWidth,
                child: ProductCard(
                  product: product,
                  imageHeight: 180,
                  onTap: () => _open(product),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptySearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 65, horizontal: 20),
      child: Column(
        children: [
          const AppIcon('search', size: 34, color: AppTheme.muted),
          const SizedBox(height: 10),
          Text(
            'No encontramos coincidencias',
            style: AppTheme.playfair(size: 20, weight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            'Prueba con otro nombre o elimina los filtros.',
            textAlign: TextAlign.center,
            style: AppTheme.poppins(size: 11, color: AppTheme.muted),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => setState(() {
              _searchController.clear();
              _activeFilter = 'Todos';
            }),
            child: Text(
              'Limpiar búsqueda',
              style: AppTheme.poppins(
                size: 12,
                weight: FontWeight.w600,
                color: AppTheme.wine,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
