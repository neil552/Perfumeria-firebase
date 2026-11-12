/// Utilidades de formato para la aplicación.
library;

/// Formatea un valor numérico como precio en soles.
///
/// Equivale a la función `soles(value)` del proyecto React original:
/// `S/ 89.90`.
String soles(num value) => 'S/ ${value.toStringAsFixed(2)}';
