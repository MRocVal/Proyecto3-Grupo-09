# PASO 1_____________Leemos los datos

data16 = read.csv('Datos/CSV 2016/Hoja de Recogida de Datos 2016.csv')
data17_18 = read.csv('Datos/CSV 2017_cod/Hoja de Recogida de Datos 20172018.csv')
#data17_188 = read.csv('Datos/CSV 2017_eti/Hoja de Recogida de Datos 20172018.csv')
data18_19 = read.csv('Datos/CSV 2018/Hoja de Recogida de Datos 20182019.csv')

# PASO 2_____________Unimos todos los DF

data18_19$Tipo.de.cirugía

# Combinar los DataFrames en uno solo
combined_df <- rbind(data16, data17_18, data18_19)


# Sustitucion de de duracion de intervencion
combined_df$Duración.de.la.intervención.quirúrgica
combined_df$Duración.de.la.intervención.quirúrgica <- ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 2, "0-5",
                                                             ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 3, "5-10",
                                                                    ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 4, "10-20",
                                                                           ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 5, "20-40",
                                                                                  ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 6, "40-60",
                                                                                         ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 7, "60-90",
                                                                                                ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 8, "90-120",
                                                                                                       # Lo mostramos
                                                                                                       ifelse(combined_df$Duración.de.la.intervención.quirúrgica == 9, "120-180", NA))))))))
combined_df$Duración.de.la.intervención.quirúrgica

# Exportar el DataFrame combinado a un archivo CSV
write.csv(combined_df, "combined_dataframe_preparacion.csv", row.names = FALSE)

# Hago unos cambios desde excel, y los cargo de nuevo

data = read.csv('Arreglo_datos/combianted_Total.csv')

summary(data)

datos_Patologia_Sistemica <- data[, 1:59]
summary(datos_Patologia_Sistemica)

# Transformamos a binario 
library(caret)

# Convertir la columna categórica en variables binarias directamente en el mismo dataframe
df<- predict(dummyVars(~ Alcohol, data = datos_Patologia_Sistemica, levelsOnly = TRUE), newdata = datos_Patologia_Sistemica)
df$Genero <- ifelse(df$genio == "Mujer", 0, 1)

# Muestra el dataframe resultante
print(df)
# Mostrar el resultado
df

df <- cbind(df, datos_Patologia_Sistemica)
df

summary(df)




# Por ultimo, eliminamos las columnas que no vayamos a meter en el cluster


# Instalar y cargar el paquete dplyr si aún no lo has hecho
# install.packages("dplyr")
library(dplyr)
# Eliminar las columnas "B" y "C"
df <- select(df, -Alcohol, -Fecha_intervencion, -Fecha_Nacimiento)


