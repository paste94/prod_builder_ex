from app.classes import ContractType
from app.tax_rules_2026 import CITY_ADDITION
from app.tax_rules_2026 import REGIONAL_ADDITION
from ast import Dict
from app.tax_rules_2026 import DEDUCTION_RATE
from decimal import Decimal
from enum import Enum

#https://www.money.it/stipendio-netto-da-lordo-calcolo-nuova-formula#La-detrazione-extra-introdotta-dalla-legge-di-Bilancio-2025
from app.tax_rules_2026 import (
    INPS_PRIVATE_RATE,
    INPS_PUBLIC_RATE,
    INPS_SPECIAL_RATE,
    INPS_HIGH_INCOME_ADDITION,
    INPS_HIGH_INCOME_THRESHOLD,
    INPS_MAX_ANNUAL,
    IRPEF_RATE,
)

CENT = Decimal("0.01")


def calc_inps(gross_salary: Decimal, type: ContractType) -> Decimal:
    match type:
        case ContractType.PRIVATE:
            rate = INPS_PRIVATE_RATE
        case ContractType.PUBLIC:
            rate = INPS_PUBLIC_RATE
        case ContractType.SPECIAL:
            rate = INPS_SPECIAL_RATE

    if gross_salary >= INPS_HIGH_INCOME_THRESHOLD:
        rate += INPS_HIGH_INCOME_ADDITION

    inps = gross_salary * rate
    if inps > INPS_MAX_ANNUAL:
        return INPS_MAX_ANNUAL
    return inps.quantize(CENT)
    
def calc_irpef(taxable_income: Decimal) -> Decimal:
    irpef = 0
    
    for i in range(len(IRPEF_RATE)):
        range_min = IRPEF_RATE[i]["from"]
        range_max = IRPEF_RATE[i]["upto"]
        rate = IRPEF_RATE[i]["rate"]

        if taxable_income <= range_max:
            irpef += (taxable_income - range_min) * rate
            break
        else:
            irpef += (range_max - range_min) * rate
    
    return irpef.quantize(CENT)

def calc_deduction(taxable_income: Decimal) -> Decimal:
    deduction = 0

    for year in DEDUCTION_RATE:
        year_deductions = DEDUCTION_RATE[year]
        for i in range(len(year_deductions)):
            range_min = year_deductions[i]["from"]
            range_max = year_deductions[i]["upto"]
            rate_fun = year_deductions[i]["rate_fun"]

            if range_min <= taxable_income < range_max:
                deduction += rate_fun(taxable_income)
                break
    
    return deduction.quantize(CENT)

def calc_regional_addition(taxable_income: Decimal, region: str = 'Lombardia') -> Decimal:
    for i in range(len(REGIONAL_ADDITION[region])):
        range_min = REGIONAL_ADDITION[region][i]["from"]
        range_max = REGIONAL_ADDITION[region][i]["upto"]
        rate = Decimal(REGIONAL_ADDITION[region][i]["rate"])

        if range_min <= taxable_income < range_max:
            return (taxable_income * rate).quantize(CENT)


def calc_city_addition(taxable_income: Decimal, city: str = 'Milano') -> Decimal:
    for i in range(len(CITY_ADDITION[city])):
        range_min = CITY_ADDITION[city][i]["from"]
        range_max = CITY_ADDITION[city][i]["upto"]
        rate = Decimal(CITY_ADDITION[city][i]["rate"])

        if range_min <= taxable_income < range_max:
            return (taxable_income * rate).quantize(CENT)

def calc_net_from_gross(gross_salary: Decimal, type: ContractType, salary_payments: int) -> Dict:
    inps = calc_inps(gross_salary, type)
    taxable_income = gross_salary - inps

    irpef = calc_irpef(taxable_income)
    deduction = calc_deduction(taxable_income)

    regional_addition = calc_regional_addition(taxable_income)
    city_addition = calc_city_addition(taxable_income)

    ded_irpef = irpef - deduction

    if ded_irpef < 0:
        ded_irpef = 0
    

    net_salary = taxable_income - ded_irpef - regional_addition - city_addition
    return {
        "inps": inps, 
        "taxable_income": taxable_income, 
        "irpef": irpef, 
        "deduction": deduction, 
        "ded_irpef": ded_irpef, 
        "regional_addition": regional_addition,
        "city_addition": city_addition,
        "net_salary": net_salary, 
        "monthly_salary": (net_salary/Decimal(salary_payments)).quantize(CENT)
    }


