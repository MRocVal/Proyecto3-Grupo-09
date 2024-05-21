#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 18 08:47:53 2024

@author: manuelrocamoravalenti
"""
import streamlit as st
import pandas as pd
import numpy as np
import joblib
from datacleaner import autoclean

# Cargar el modelo previamente guardado
model = joblib.load('best_xgb_model.pkl')

# Función para realizar predicciones
def predict(input_data):
    df = pd.DataFrame([input_data])
    clean_df = autoclean(df)  # Limpieza automática de datos
    pred = model.predict(clean_df)
    return pred

def main():
    st.title("Predictor de Duración de Intervenciones Dentales")

    with st.form(key='input_form'):
        # Definición de campos de entrada
        tipo_intervencion_quirurjica = st.selectbox('Tipo de Intervención Quirúrgica', ['Cirugía Dentoalveolar', 'Cirugía Peri-implantaria', 'Implantología Bucal'])
        Alcohol = st.selectbox('Alcohol', ['No consumo', 'Consumo moderado', 'Consumo elevado'])
        Medicacion_Actual = st.selectbox('Medicación Actual', ['No', 'Sí'])
        Otras_Drogas = st.multiselect('Otras Drogas', ['No', 'Sí'])
        Tipo_de_protesis_sobre_implantes = st.selectbox('Tipo de prótesis sobre implantes', ['Corona unitaria', 'Puente sobre implantes', 'Prótesis híbrida', 'Sobredentadura', 'Full-arch metal-cerámica'])
        Tipo_de_cirugia = st.selectbox('Tipo de cirugía', ['Cirugía combinada (regenerativa + implantoplastia)', 'Cirugía de acceso', 'Cirugía resectiva', 'Cirugía regenerativa'])
        opciones = ['Id', 'No', 'Implante 1 - Defecto tipo I (infraóseo)', 'Ib', 'Ic', 'Ie']
        Implante_1_Defecto_tipo_I_infraoseo = st.selectbox('Selecciona una opción para Implante 1 - Defecto tipo I (infraóseo):', options=opciones)
        X_material_regeneracion = st.selectbox('Qué material de regeneración ha sido utilizado', ['Xenoinjerto (Bio-Oss) + Membrana de colágeno reabsorbible (Bio-Gide)'])
        Número_de_implantes = st.selectbox('Número de implantes', [0, 1, 2, 3, 4, 6])
        Caracteristicas_del_implante = st.selectbox('Características del implante', [0, 12, 21, 11, 36, 23, 45, 16])

        submit_button = st.form_submit_button(label='Predecir')

    if submit_button:
        input_data = [tipo_intervencion_quirurjica, Alcohol, Medicacion_Actual, Otras_Drogas, Tipo_de_protesis_sobre_implantes, Tipo_de_cirugia, Implante_1_Defecto_tipo_I_infraoseo, X_material_regeneracion, Número_de_implantes, Caracteristicas_del_implante]
        prediction = predict(input_data)
        st.write(f"La predicción de duración de la intervención es: {prediction[0]} minutos")
        # Opcionalmente, guardar datos limpios
        clean_df = pd.DataFrame([input_data])
        autoclean(clean_df).to_csv("data_clean.csv", index=False)
        st.write("Datos limpios guardados.")

if __name__ == "__main__":
    main()



