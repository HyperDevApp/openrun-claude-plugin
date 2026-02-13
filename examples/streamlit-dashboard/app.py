"""
Streamlit Dashboard Example
A simple data visualization dashboard demonstrating OpenRun deployment
"""

import streamlit as st
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Page configuration
st.set_page_config(
    page_title="Analytics Dashboard",
    page_icon="📊",
    layout="wide"
)

# Title and description
st.title("📊 Analytics Dashboard")
st.markdown("**Example dashboard deployed with OpenRun**")

# Sidebar
with st.sidebar:
    st.header("Filters")
    date_range = st.slider(
        "Date Range (days)",
        min_value=7,
        max_value=90,
        value=30
    )
    metric_type = st.selectbox(
        "Metric Type",
        ["Revenue", "Users", "Sessions", "Conversions"]
    )

# Generate sample data
@st.cache_data
def generate_data(days, metric):
    dates = [datetime.now() - timedelta(days=x) for x in range(days)]
    dates.reverse()

    base_value = {
        "Revenue": 10000,
        "Users": 1000,
        "Sessions": 5000,
        "Conversions": 500
    }[metric]

    values = [base_value + np.random.randint(-base_value//10, base_value//10) for _ in range(days)]

    return pd.DataFrame({
        "Date": dates,
        "Value": values
    })

# Main content
df = generate_data(date_range, metric_type)

# Metrics
col1, col2, col3 = st.columns(3)

with col1:
    st.metric(
        label=f"Total {metric_type}",
        value=f"{df['Value'].sum():,.0f}",
        delta=f"{((df['Value'].iloc[-1] - df['Value'].iloc[0]) / df['Value'].iloc[0] * 100):.1f}%"
    )

with col2:
    st.metric(
        label=f"Average {metric_type}",
        value=f"{df['Value'].mean():,.0f}"
    )

with col3:
    st.metric(
        label=f"Max {metric_type}",
        value=f"{df['Value'].max():,.0f}"
    )

# Line chart
st.subheader(f"{metric_type} Trend")
st.line_chart(df.set_index("Date"))

# Data table
with st.expander("View Raw Data"):
    st.dataframe(df, use_container_width=True)

# Footer
st.markdown("---")
st.markdown("*Deployed with [OpenRun](https://openrun.dev) + [Claude Code](https://code.claude.com)*")
