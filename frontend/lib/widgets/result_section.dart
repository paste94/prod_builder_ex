import 'package:flutter/material.dart';
import 'package:frontend/models.dart';
import 'package:frontend/widgets/cake_diagram.dart';

class ResultSection extends StatelessWidget {
  final SalaryResponse result;
  const ResultSection({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildResultRow(
              'Estimated annual net salary',
              _formatMoney(result.netSalary),
            ),
            _buildResultRow(
              'Estimated monthly net salary (13 payments)',
              _formatMoney(result.monthlySalary),
            ),
            const Divider(height: 32),
            // LayoutBuilder(
            //   builder: (context, constraints) {
            //     if (constraints.maxWidth > 700) {
            //       return Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Expanded(child: _buildBreakdown(result)),
            //           const SizedBox(width: 16),
            //           Expanded(child: CakeDiagram(result: result)),
            //         ],
            //       );
            //     } else {
            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           _buildBreakdown(result),
            //           const SizedBox(height: 16),
            //           CakeDiagram(result: result),
            //         ],
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

Widget _buildResultRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget _buildBreakdown(SalaryResponse result) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Breakdown',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      _buildBreakdownRow('INPS contributions', result.inps),
      _buildBreakdownRow('Taxable income', result.taxableIncome),
      _buildBreakdownRow('Gross IRPEF', result.irpef),
      _buildBreakdownRow('Employment tax deduction', result.deduction),
      _buildBreakdownRow('Net IRPEF', result.dedIrpef),
      _buildBreakdownRow('Regional surtax', result.regionalAddition),
      _buildBreakdownRow('Municipal surtax', result.cityAddition),
    ],
  );
}

Widget _buildBreakdownRow(String label, double value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(_formatMoney(value))],
    ),
  );
}

String _formatMoney(double amount) {
  final text = amount.toStringAsFixed(2);
  final parts = text.split('.');
  final integerPart = parts[0];
  final decimalPart = parts[1];
  return '€ ${integerPart}.$decimalPart';
}
