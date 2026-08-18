from decimal import Decimal


def ded_rate_2026_1(_) -> Decimal:
    return Decimal(1955)

def ded_rate_2026_2(salary:Decimal) -> Decimal:
    return Decimal(1910 + 1190 * (28000 - salary) / (28000 - 15000))

def ded_rate_2026_3(salary:Decimal) -> Decimal:
    return Decimal(1910 * (50000 - salary) / (50000 - 28000))

def ded_rate_2026_4(_) -> Decimal:
    return Decimal(0)

def ded_rate_2025_1(_) -> Decimal:
    return Decimal(1000)

def ded_rate_2025_2(salary:Decimal) -> Decimal:
    return Decimal(1000*(40000-salary)/(8000))

def ded_rate_2025_3(_) -> Decimal:
    return Decimal(0)

def ded_rate_int_1(salary:Decimal) -> Decimal:
    return salary * Decimal(0.071)

def ded_rate_int_2(salary:Decimal) -> Decimal:
    return salary * Decimal(0.053)

def ded_rate_int_3(salary:Decimal) -> Decimal:
    return salary * Decimal(0.048)

def ded_rate_int_4(_) -> Decimal:
    return Decimal(0)


TAX_YEAR = 2026

# 33% total (9,19% employee, 23,81% employer)
# This calculation only considers the 9,19% employee share.
# https://www.faroconsulenze.it/2026/01/19/guida-completa-ai-contributi-previdenziali-2026_-inps-cassa-forense-e-inarcassa/
INPS_PRIVATE_RATE = Decimal(0.0919)
INPS_PUBLIC_RATE = Decimal(0.0880)
INPS_SPECIAL_RATE = Decimal(0.0885)

INPS_HIGH_INCOME_ADDITION = Decimal(0.01)
INPS_HIGH_INCOME_THRESHOLD = Decimal(56224)

INPS_MAX_ANNUAL = Decimal(122295)

IRPEF_RATE = [
    {"from": Decimal(0), "upto":Decimal(28000), "rate": Decimal(0.23)},
    {"from": Decimal(28000), "upto":Decimal(50000), "rate": Decimal(0.33)},
    {"from": Decimal(50000), "upto":Decimal('Infinity'), "rate": Decimal(0.43)}
]

DEDUCTION_RATE = {
    "2026": [
        {"from": Decimal(0), "upto":Decimal(15000), "rate_fun": ded_rate_2026_1},
        {"from": Decimal(15000), "upto":Decimal(28000), "rate_fun": ded_rate_2026_2},
        {"from": Decimal(28000), "upto":Decimal(50000), "rate_fun": ded_rate_2026_3},
        {"from": Decimal(50000), "upto":Decimal('Infinity'), "rate_fun": ded_rate_2026_4}
    ],
    "2025":[
        {"from": Decimal(0), "upto":Decimal(32000), "rate_fun": ded_rate_2025_1},
        {"from": Decimal(32000), "upto":Decimal(40000), "rate_fun": ded_rate_2025_2},
        {"from": Decimal(50000), "upto":Decimal('Infinity'), "rate_fun": ded_rate_2025_3}
    ],
    "integrativo":[
        
        {"from": Decimal(0), "upto":Decimal(8500), "rate_fun": ded_rate_int_1},
        {"from": Decimal(8500), "upto":Decimal(15000), "rate_fun": ded_rate_int_2},
        {"from": Decimal(15000), "upto":Decimal(20000), "rate_fun": ded_rate_int_3},
        {"from": Decimal(20000), "upto":Decimal('Infinity'), "rate_fun": ded_rate_int_4}
    
    ]
}

# https://www.businessonline.it/news/addizionale-irpef-lombardia-2026-quando-si-paga-percentuali-aggiornate-tassazione-dipendenti-e-pensionati-calcoli-ed-esempi_n82272.html
REGIONAL_ADDITION = {
    "Lombardia": [
        {"from": Decimal(0), "upto":Decimal(15000), "rate": Decimal(0.0123)},
        {"from": Decimal(15000), "upto":Decimal(28000), "rate": Decimal(0.0158)},
        {"from": Decimal(28000), "upto":Decimal(55000), "rate": Decimal(0.0173)},
        {"from": Decimal(55000), "upto":Decimal(75000), "rate": Decimal(0.0178)},
        {"from": Decimal(75000), "upto":Decimal('Infinity'), "rate": Decimal(0.0185)}
    ]
}

# https://www.comune.milano.it/argomenti/tributi/addizionale-comunale-irpef
CITY_ADDITION = {
    "Milano": [
        {"from": Decimal(0), "upto":Decimal(23000), "rate": Decimal(0.00)},
        {"from": Decimal(23000), "upto":Decimal('Infinity'), "rate": Decimal(0.008)}
    ]
}

    