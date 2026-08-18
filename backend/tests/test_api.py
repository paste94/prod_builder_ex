from app.classes import ContractType
from decimal import Decimal

from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_endpoint():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_net_salary_estimate_private_contract():
    payload = {
        "gross_salary": 30000,
        "salary_payments": 12,
        "contract_type": ContractType.PRIVATE.value,
    }

    response = client.post("/api/v1/net-salary-estimates", json=payload)

    assert response.status_code == 200

    data = response.json()

    print(data)

    expected = {
        'inps': '2757.00', 
        'taxable_income': '27243.00', 
        'irpef': '6265.89', 
        'deduction': '2979.29', 
        'ded_irpef': '3286.60', 
        'regional_addition': '430.44', 
        'city_addition': '217.94', 
        'net_salary': '23308.02',
        'monthly_salary': '1942.34'
    }

    assert data == expected


def test_net_salary_estimate_invalid_salary():
    payload = {
        "gross_salary": -1000,
        "salary_payments": 13,
        "contract_type": ContractType.PRIVATE.value,
    }

    response = client.post("/api/v1/net-salary-estimates", json=payload)

    assert response.status_code == 422


def test_net_salary_estimate_invalid_contract_type():
    payload = {
        "gross_salary": "35000",
        "salary_payments": 13,
        "contract_type": "invalid_type",
    }

    response = client.post("/api/v1/net-salary-estimates", json=payload)

    assert response.status_code == 422