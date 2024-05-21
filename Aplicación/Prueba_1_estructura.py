#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 24 11:46:06 2024

@author: manuelrocamoravalenti
"""

import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

# Example data creation
def create_data():
    # Generating random data for demonstration: ages, types, duration
    np.random.seed(42)
    data = {
        'age': np.random.randint(20, 80, size=100),
        'type': np.random.choice(['General', 'Orthopedic', 'Cardiac'], size=100),
        'complexity': np.random.choice(['Low', 'Medium', 'High'], size=100),
        'duration': np.random.normal(120, 30, size=100)  # surgical duration in minutes
    }
    return pd.DataFrame(data)

# Model training function
def train_model(data):
    # Preprocessing: converting categorical data to numerical
    data = pd.get_dummies(data, columns=['type', 'complexity'], drop_first=True)
    
    # Features and target
    X = data.drop('duration', axis=1)
    y = data['duration']
    
    # Splitting the data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Model training
    model = LinearRegression()
    model.fit(X_train, y_train)
    
    # Predicting and evaluating
    y_pred = model.predict(X_test)
    rmse = np.sqrt(mean_squared_error(y_test, y_pred))
    
    return model, rmse

# Streamlit application function
def app():
    st.title('Surgical Time Prediction App')
    
    # Loading data
    data = create_data()
    
    # Display exploratory data analysis
    st.header('Exploratory Data Analysis')
    
    # Displaying age distribution
    fig, ax = plt.subplots()
    ax.hist(data['age'], bins=20, color='blue', alpha=0.7)
    ax.set_xlabel('Age')
    ax.set_ylabel('Frequency')
    ax.set_title('Age Distribution')
    st.pyplot(fig)
    
    # Predictive model section
    st.header('Surgical Time Prediction')
    st.write('Please enter the details of the surgery to predict the duration.')
    
    # Form for user input
    with st.form('prediction_form'):
        age = st.number_input('Age', min_value=20, max_value=80)
        surgery_type = st.selectbox('Type of Surgery', ['General', 'Orthopedic', 'Cardiac'])
        complexity = st.selectbox('Complexity', ['Low', 'Medium', 'High'])
        submit_button = st.form_submit_button('Predict Duration')
    
    if submit_button:
        # Model training
        model, rmse = train_model(data)
        
        # Encoding inputs
        input_data = {
            'age': [age],
            'type_General': [1 if surgery_type == 'General' else 0],
            'type_Orthopedic': [1 if surgery_type == 'Orthopedic' else 0],
            'complexity_Medium': [1 if complexity == 'Medium' else 0],
            'complexity_High': [1 if complexity == 'High' else 0],
        }
        input_df = pd.DataFrame(input_data)
        
        # Making prediction
        prediction = model.predict(input_df)[0]
        st.success(f'Predicted Surgery Duration: {prediction:.2f} minutes')

# Uncomment the following line to run the Streamlit app when running locally.
# app()

# Comments: This script should be saved as a `.py` file and run using Streamlit.
# The user should install all the necessary packages (`streamlit`, `pandas`, `numpy`, `matplotlib`, `sklearn`) to run the app.

