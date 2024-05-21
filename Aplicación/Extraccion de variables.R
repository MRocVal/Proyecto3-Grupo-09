# Carga de datos
data = read.csv('Datos/General_data.csv')

# Extracción de variables de interés
library(dplyr)

nuevo_df <- data %>% 
  select(Fecha.Intervención, Tipo.de.Intervención.Quirúrgica,Duración.de.la.intervención.quirúrgica,
         Fecha.de.Nacimiento,Patología.Sistémica,Medicación.Actual, Hipotensión.Arterial, Hipercolesterolemia,
         Alcohol, Fumador.a, Bifosfonatos,Técnica.de.sutura)

print(nuevo_df)

write.csv(nuevo_df, 'data_APP.csv')


