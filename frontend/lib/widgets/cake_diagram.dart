import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/models.dart';

class CakeDiagramSlice {
  final String label;
  final double value;
  final Color color;

  CakeDiagramSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}

class CakeDiagram extends StatelessWidget {
  final SalaryResponse result;

  const CakeDiagram({super.key, required this.result});

  List<CakeDiagramSlice> _getSlices() {
    return [
      CakeDiagramSlice(
        label: 'Net Salary',
        value: result.netSalary,
        color: const Color(0xFF2E7D32), // Emerald Green
      ),
      CakeDiagramSlice(
        label: 'INPS',
        value: result.inps,
        color: const Color(0xFF1565C0), // Blue
      ),
      CakeDiagramSlice(
        label: 'Net IRPEF',
        value: result.dedIrpef,
        color: const Color(0xFFE65100), // Orange
      ),
      CakeDiagramSlice(
        label: 'Regional Surtax',
        value: result.regionalAddition,
        color: const Color(0xFF6A1B9A), // Purple
      ),
      CakeDiagramSlice(
        label: 'Municipal Surtax',
        value: result.cityAddition,
        color: const Color(0xFF00838F), // Teal
      ),
    ];
  }

  String _formatMoney(double amount) {
    final text = amount.toStringAsFixed(2);
    final parts = text.split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];
    return '€ $integerPart,$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    final slices = _getSlices();
    final total = slices.fold<double>(0.0, (sum, item) => sum + item.value);

    if (total <= 0) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Salary Breakdown Diagram',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              // crossAlignment: WrapCrossAlignment.center,
              spacing: 24,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CustomPaint(
                    painter: _DonutChartPainter(slices: slices, total: total),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Net Share',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            // '${((result.netSalary / total) * 100).toStringAsFixed(1)}%',
                            _formatMoney(result.netSalary),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Monthly Salary',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            // '${((result.netSalary / total) * 100).toStringAsFixed(1)}%',
                            _formatMoney(result.monthlySalary),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 87, 87, 87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: slices.map((slice) {
                      // final percentage = (slice.value / total) * 100;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: slice.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              slice.label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              // '${_formatMoney(slice.value)} (${percentage.toStringAsFixed(1)}%)',
                              _formatMoney(slice.value),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<CakeDiagramSlice> slices;
  final double total;

  _DonutChartPainter({required this.slices, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = min(size.width, size.height) / 2;
    final strokeWidth = 24.0;
    final radius = outerRadius - strokeWidth / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    double startAngle = -pi / 2; // Start from top

    for (final slice in slices) {
      if (slice.value <= 0) continue;

      final sweepAngle = (slice.value / total) * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = slice.color
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.slices != slices || oldDelegate.total != total;
  }
}
