from fastapi import Request
from app.calculator import calc_net_from_gross
from app.classes import SalaryEstimateRequest
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Jet HR Net Salary Calculator API",
    version="1.0.0",
    description="Prototype for estimating net salary for a standard employee in Milan, Italy.",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=False,
    allow_methods=["POST", "GET"],
    allow_headers=["*"],
)

@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}

@app.post("/api/v1/net-salary-estimates")
def net_salary_estimate(payload: SalaryEstimateRequest) -> dict:
    print('HELLOOOOO')
    result = calc_net_from_gross(
        gross_salary=payload.gross_salary,
        salary_payments=payload.salary_payments,
        type=payload.contract_type
    )
    return {
        **result,
    }

@app.get("/debug-headers")
def debug_headers(request: Request):
    ret = {
        "origin": request.headers.get("origin"),
        "host": request.headers.get("host"),
        "referer": request.headers.get("referer"),
        "all_headers": dict(request.headers),
    }
    print(ret)
    return ret