import 'package:flutter/material.dart';
import 'package:frontend/models.dart';

class InputSection extends StatefulWidget {
  final ContractType selectedContract;
  final TextEditingController ralController;
  final void Function(ContractType) onContractSelected;
  final void Function(int) onSalaryPaymentsSelected;
  final void Function() onCalculate;
  final GlobalKey<FormState> formKey;

  const InputSection({
    super.key,
    required this.selectedContract,
    required this.ralController,
    required this.onContractSelected,
    required this.onSalaryPaymentsSelected,
    required this.onCalculate,
    required this.formKey,
  });

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  @override
  void dispose() {
    widget.ralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Annual Gross Salary (RAL)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.ralController,
                decoration: const InputDecoration(
                  labelText: 'EUR',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  try {
                    final parsed = double.parse(value.replaceAll(',', '.'));
                    if (parsed <= 0) {
                      return 'Enter a value greather than 0';
                    }
                  } catch (_) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Contract Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<ContractType>(
                initialValue: widget.selectedContract,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: ContractType.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    widget.onContractSelected(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Salary Payments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: 12,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [12, 13, 14]
                    .map(
                      (c) =>
                          DropdownMenuItem(value: c, child: Text(c.toString())),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    widget.onSalaryPaymentsSelected(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onCalculate,
                child: const Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
