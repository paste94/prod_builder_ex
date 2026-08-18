
from decimal import Decimal
from pydantic import BaseModel, Field, field_validator
from enum import Enum

class ContractType(Enum):
    PRIVATE = "PRIVATE"
    PUBLIC = "PUBLIC"
    SPECIAL = "SPECIAL"

class SalaryEstimateRequest(BaseModel):
    gross_salary: Decimal = Field(
        gt=0,
        description="Gross annual salary (RAL), in EUR",
    )
    salary_payments: int = Field(default=13, ge=12, le=14)
    contract_type: ContractType = Field(
        default=ContractType.PRIVATE,
        description="Type of employment contract",
    )

    @field_validator("gross_salary", mode="before")
    @classmethod
    def parse_gross_salary(cls, value):
        if isinstance(value, (int, float)):
            return Decimal(str(value))
        if isinstance(value, str):
            return Decimal(value.replace(",", "."))
        return value