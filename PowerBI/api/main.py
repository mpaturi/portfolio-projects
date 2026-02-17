# main FastAPI app for AdventureWorks KPIs
from fastapi import FastAPI

app = FastAPI()

#health check endpoint
@app.get("/health")
def health_check():
    return {"status": "ok"}

# KPIs endpoint returning hardcoded values
@app.get("/kpis")
def get_kpis():
    return {
        "total_sales_2011_2014": 59094490.27,
         "yoy_sales_percent_by_year": {
            "2012": 1.47,
            "2013": 0.98,
            "2014": -0.47
        },
        "total_orders_2011_2014": 17000
    }
    
# # executive summary endpoint (template based for now)
# @app.get("/explain-kpis")
# def explain_kpis():
#     return {
#         "summary": (
#             "From 2011–2014, AdventureWorks generated about $59M in sales "
#             "across roughly 17K orders, with an average order value around $3.5K. "
#             "Revenue peaks in 2013, then drops in partial year 2014, turning year-over-year performance negative compared to prior growth years."
#         )
#     }
    
# executive summary endpoint powered by ai/summary_chain
from ai.summary_chain import generate_kpi_summary

@app.get("/explain-kpis")
def explain_kpis():
    # fetch KPIs (for now, reuse the same hard-coded dict)
    kpis = {
        "total_sales_2011_2014": 59094490.27,
        "yoy_sales_percent_by_year": {
            "2012": 1.47,
            "2013": 0.98,
            "2014": -0.47
        },
        "total_orders_2011_2014": 17000
    }
    
    summary = generate_kpi_summary(kpis)
    
    return {"summary": summary}
