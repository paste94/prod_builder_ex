import 'package:flutter/material.dart';
import 'package:frontend/salary_api.dart';
import 'package:frontend/widgets/assumption_section.dart';
import 'package:frontend/widgets/cake_diagram.dart';
import 'package:frontend/widgets/input_section.dart';
import 'package:frontend/widgets/result_section.dart';
import 'models.dart';

void main() {
  runApp(const NetSalaryCalculatorApp());
}

class NetSalaryCalculatorApp extends StatelessWidget {
  const NetSalaryCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jet HR Net Salary Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SalaryCalculatorPage(),
    );
  }
}

class SalaryCalculatorPage extends StatefulWidget {
  const SalaryCalculatorPage({super.key});

  @override
  State<SalaryCalculatorPage> createState() => _SalaryCalculatorPageState();
}

class _SalaryCalculatorPageState extends State<SalaryCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _ralController = TextEditingController(text: '35000');

  ContractType _selectedContract = ContractType.private;
  int _salaryPayments = 12;

  SalaryResponse? _result;
  bool _loading = false;
  String? _error;

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final gross = double.parse(_ralController.text.replaceAll(',', '.'));
      final estimate = await SalaryApi.calculateNetSalary(
        salaryRequest: SalaryRequest(
          grossSalary: gross,
          salaryPayments: _salaryPayments,
          contractType: _selectedContract,
        ),
      );
      setState(() {
        _result = estimate;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jet HR Net Salary Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: InputSection(
                    selectedContract: _selectedContract,
                    ralController: _ralController,
                    onContractSelected: (value) {
                      setState(() {
                        _selectedContract = value;
                      });
                    },
                    onSalaryPaymentsSelected: (value) {
                      setState(() {
                        _salaryPayments = value;
                      });
                    },
                    onCalculate: _calculate,
                    formKey: _formKey,
                  ),
                ),
                const SizedBox(width: 24),
                const Flexible(flex: 2, child: AssumptionSection()),
              ],
            ),

            const SizedBox(height: 24),
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            ],
            if (_result != null) ...[
              const SizedBox(height: 16),
              // ResultSection(result: _result!),
              CakeDiagram(result: _result!),
            ],
          ],
        ),
      ),
    );
  }

  // Widget _buildInputSection() {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               'Annual Gross Salary (RAL)',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             TextFormField(
  //               controller: _ralController,
  //               decoration: const InputDecoration(
  //                 labelText: 'EUR',
  //                 border: OutlineInputBorder(),
  //               ),
  //               keyboardType: const TextInputType.numberWithOptions(
  //                 decimal: true,
  //               ),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Required';
  //                 }
  //                 try {
  //                   final parsed = double.parse(value.replaceAll(',', '.'));
  //                   if (parsed <= 0) {
  //                     return 'Enter a value greather than 0';
  //                   }
  //                 } catch (_) {
  //                   return 'Invalid number';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             const SizedBox(height: 16),
  //             const Text(
  //               'Contract Type',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             DropdownButtonFormField<ContractType>(
  //               value: _selectedContract,
  //               decoration: const InputDecoration(border: OutlineInputBorder()),
  //               items: ContractType.values
  //                   .map(
  //                     (c) => DropdownMenuItem(
  //                       value: c,
  //                       child: Text(c.name.toUpperCase()),
  //                     ),
  //                   )
  //                   .toList(),
  //               onChanged: (value) {
  //                 if (value != null) {
  //                   setState(() {
  //                     _selectedContract = value;
  //                   });
  //                 }
  //               },
  //             ),
  //             const SizedBox(height: 16),
  //             ElevatedButton(
  //               onPressed: _loading ? null : _calculate,
  //               child: const Text('Calculate'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildResultsSection(SalaryResponse result) {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Results',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 16),
  //           _buildResultRow(
  //             'Estimated annual net salary',
  //             _formatMoney(result.netSalary),
  //           ),
  //           _buildResultRow(
  //             'Estimated monthly net salary (13 payments)',
  //             _formatMoney(result.monthlySalary),
  //           ),
  //           const Divider(height: 32),
  //           _buildBreakdown(result),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildResultRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(label),
  //         Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildBreakdown(SalaryResponse result) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Breakdown',
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 8),
  //       _buildBreakdownRow('INPS contributions', result.inps),
  //       _buildBreakdownRow('Taxable income', result.taxableIncome),
  //       _buildBreakdownRow('Gross IRPEF', result.irpef),
  //       _buildBreakdownRow('Employment tax deduction', result.deduction),
  //       _buildBreakdownRow('Net IRPEF', result.dedIrpef),
  //       _buildBreakdownRow('Regional surtax', result.regionalAddition),
  //       _buildBreakdownRow('Municipal surtax', result.cityAddition),
  //     ],
  //   );
  // }

  // Widget _buildBreakdownRow(String label, double value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 2),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [Text(label), Text(_formatMoney(value))],
  //     ),
  //   );
  // }

  Widget _buildAssumptionsSection() {
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
              '- 13 salary payments\n'
              '- No dependants, benefits, bonuses or special tax regimes\n\n'
              'Results are indicative and do not replace an official payroll calculation.',
            ),
          ],
        ),
      ),
    );
  }

  // String _formatMoney(double amount) {
  //   final text = amount.toStringAsFixed(2);
  //   final parts = text.split('.');
  //   final integerPart = parts[0];
  //   final decimalPart = parts[1];
  //   return '€ ${integerPart}.$decimalPart';
  // }

  @override
  void dispose() {
    _ralController.dispose();
    super.dispose();
  }
}
