import 'package:flutter/material.dart';

class AssumptionSection extends StatelessWidget {
  const AssumptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assumptions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This prototype estimates net salary for a standard employee:\n'
              '- Permanent contract (PRIVATE sector)\n'
              '- Resident in Milan, Lombardy\n'
              '- Tax year 2026\n'
              '- No dependants, benefits, bonuses or special tax regimes\n\n',
            ),
          ],
        ),
      ),
    );
  }
}
