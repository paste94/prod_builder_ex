import 'package:flutter/material.dart';
import 'package:frontend/salary_api.dart';
import 'package:frontend/widgets/assumption_section.dart';
import 'package:frontend/widgets/cake_diagram.dart';
import 'package:frontend/widgets/input_section.dart';
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
              CakeDiagram(result: _result!),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ralController.dispose();
    super.dispose();
  }
}
