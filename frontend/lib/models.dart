class SalaryRequest {
  final double grossSalary;
  final int salaryPayments;
  final ContractType contractType;

  SalaryRequest({
    required this.grossSalary,
    required this.salaryPayments,
    required this.contractType,
  });

  Map<String, dynamic> toJson() => {
    "gross_salary": grossSalary,
    "salary_payments": salaryPayments,
    "contract_type": contractType.toApiValue(),
  };
}

class SalaryResponse {
  final double inps;
  final double taxableIncome;
  final double irpef;
  final double deduction;
  final double dedIrpef;
  final double regionalAddition;
  final double cityAddition;
  final double netSalary;
  final double monthlySalary;

  SalaryResponse({
    required this.inps,
    required this.taxableIncome,
    required this.irpef,
    required this.deduction,
    required this.dedIrpef,
    required this.regionalAddition,
    required this.cityAddition,
    required this.netSalary,
    required this.monthlySalary,
  });

  factory SalaryResponse.fromJson(Map<String, dynamic> json) {
    return SalaryResponse(
      inps: double.parse(json['inps']),
      taxableIncome: double.parse(json['taxable_income']),
      irpef: double.parse(json['irpef']),
      deduction: double.parse(json['deduction']),
      dedIrpef: double.parse(json['ded_irpef']),
      regionalAddition: double.parse(json['regional_addition']),
      cityAddition: double.parse(json['city_addition']),
      netSalary: double.parse(json['net_salary']),
      monthlySalary: double.parse(json['monthly_salary']),
    );
  }
}

enum ContractType { private, public, special }

extension ContractTypeX on ContractType {
  String toApiValue() {
    switch (this) {
      case ContractType.private:
        return 'PRIVATE';
      case ContractType.public:
        return 'PUBLIC';
      case ContractType.special:
        return 'SPECIAL';
    }
  }

  static ContractType fromApiValue(String value) {
    switch (value) {
      case 'PRIVATE':
        return ContractType.private;
      case 'PUBLIC':
        return ContractType.public;
      case 'SPECIAL':
        return ContractType.special;
      default:
        throw FormatException('Invalid ContractType: $value');
    }
  }
}
