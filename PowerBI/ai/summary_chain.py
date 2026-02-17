# ai/summary_chain.py
# LLM-powered summary using Ollama + LangChain

from typing import Dict
from langchain_ollama import OllamaLLM

# Initialize the local Llama model
llm = OllamaLLM(model="llama3.2:1b")

def generate_kpi_summary(kpis: Dict) -> str:
    """
    Generate an executive summary of the AdventureWorks sales KPIs
    using a local LLM via Ollama.
    """
    # Build the prompt with KPI data
    prompt = f"""You are a sales executive writing a brief summary for leadership.

Summarize these AdventureWorks sales KPIs in 2-3 sentences:
- Total sales (2011-2014): ${kpis['total_sales_2011_2014']:,.2f}
- Total orders: {kpis['total_orders_2011_2014']:,}
- Year-over-year growth by year: {kpis['yoy_sales_percent_by_year']}

Focus on the overall trend and any notable changes in growth."""

    # Call the LLM and return its response
    summary = llm.invoke(prompt)
    return summary
