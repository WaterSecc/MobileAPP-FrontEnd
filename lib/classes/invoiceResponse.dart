class InvoiceResponse {
  final num sonedeAmount;
  final num onasAmount;
  final num totalAmount;
  final num consumptionPercentLevel;
  final num consumptionLevel;

  InvoiceResponse({
    required this.sonedeAmount,
    required this.onasAmount,
    required this.totalAmount,
    required this.consumptionPercentLevel,
    required this.consumptionLevel,
  });
}