from app.classes import ContractType
from decimal import Decimal
from app.calculator import calc_inps, calc_irpef, calc_net_from_gross

CENT = Decimal("0.01")

def test_calc_inps_1k_private():
    # 1000 * 0.0919 = 91.9
    
    salary = Decimal(1000)  
    expected = Decimal(91.9)

    assert calc_inps(salary, ContractType.PRIVATE) == expected.quantize(CENT)

def test_calc_inps_1k_public():
    # 1000 * 0.0880 = 88.0

    salary = Decimal(1000)
    expected = Decimal(88.0)

    assert calc_inps(salary, ContractType.PUBLIC) == expected.quantize(CENT)

def test_calc_inps_1k_special():
    # 1000 * 0.0885 = 88.5

    salary = Decimal(1000)
    expected = Decimal(88.5)

    assert calc_inps(salary, ContractType.SPECIAL) == expected.quantize(CENT)

def test_calc_inps_high_income():
    salary = Decimal(60000)
    expected = Decimal(6114.00)

    assert calc_inps(salary, ContractType.PRIVATE) == expected.quantize(CENT)

def test_calc_inps_zero_income():
    salary = Decimal(0)
    expected = Decimal(0)

    assert calc_inps(salary, ContractType.PRIVATE) == expected.quantize(CENT)

def test_calc_inps_max_annual():
    salary = Decimal(15000000)
    expected = Decimal(122295)

    assert calc_inps(salary, ContractType.PRIVATE) == expected.quantize(CENT)

def test_calc_irpef_1k():
    salary = Decimal(1000)
    expected = Decimal(230)

    assert calc_irpef(salary) == expected.quantize(CENT)

def test_calc_irpef_28k():
    salary = Decimal(28000)
    expected = Decimal(6440)

    assert calc_irpef(salary) == expected.quantize(CENT)

def test_calc_inps_30k():
    salary = Decimal(30000)
    expected = Decimal(2757)

    assert calc_inps(salary, ContractType.PRIVATE) == expected.quantize(CENT)

def test_calc_net_from_gross_30k():
    salary = Decimal(30000)
    expected = {
        'inps': Decimal('2757.00'), 
        'taxable_income': Decimal('27243.00'), 
        'irpef': Decimal('6265.89'), 
        'deduction': Decimal('2979.29'), 
        'ded_irpef': Decimal('3286.60'), 
        'regional_addition': Decimal('430.44'), 
        'city_addition': Decimal('217.94'), 
        'net_salary': Decimal('23308.02'),
        'monthly_salary': Decimal('1942.34')
    }
    
    
    contract_type = ContractType.PRIVATE

    res = calc_net_from_gross(salary, contract_type, salary_payments=12)

    print (res)

    assert res == expected

def test_calc_net_from_gross_8k():
    salary = Decimal(8000)
    expected = {
        'inps': Decimal('735.20'), 
        'taxable_income': Decimal('7264.80'), 
        'irpef': Decimal('1670.90'), 
        'deduction': Decimal('3470.80'), 
        'ded_irpef': 0, 
        'regional_addition': Decimal('89.36'), 
        'city_addition': Decimal('0.00'), 
        'net_salary': Decimal('7175.44'),
        'monthly_salary': Decimal('597.95')
    }
    contract_type = ContractType.PRIVATE

    res = calc_net_from_gross(salary, contract_type, salary_payments=12)

    print (res)

    assert res == expected

def test_calc_net_from_gross_1m():
    salary = Decimal(1000000)
    expected = {
        'inps': Decimal('101900.00'), 
        'taxable_income': Decimal('898100.00'), 
        'irpef': Decimal('378383.00'), 
        'deduction': Decimal('0.00'), 
        'ded_irpef': Decimal('378383.00'), 
        'regional_addition': Decimal('16614.85'), 
        'city_addition': Decimal('7184.80'), 
        'net_salary': Decimal('495917.35'),
        'monthly_salary': Decimal('41326.45')
    }
    contract_type = ContractType.PRIVATE

    res = calc_net_from_gross(salary, contract_type, salary_payments=12)

    print (res)

    assert res == expected