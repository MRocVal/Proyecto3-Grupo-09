#:::::::::::::: Lectura de datos
data_g = read.csv('Datos_Limpios/General_data.csv')
data_Patho = read.csv('Datos_Limpios/Systemic_Pathology.csv')

#........... Arreglos en data_Patho
# Eliminar variables
data_Patho <- subset(data_Patho, select = -c(2,3,4,5,6,7,8,9,13,14))
data_Patho <- subset(data_Patho, select = -c(15))
head(data_Patho)

# Calculo de la edad del paciente
library(lubridate)

data_Patho$Fecha.de.Nacimiento <- as.Date(data_Patho$Fecha.de.Nacimiento, format = "%d/%m/%Y")
hoy <- Sys.Date()
data_Patho$edad_Pacientes <- as.numeric(difftime(hoy, data_Patho$Fecha.de.Nacimiento, units = "days")/365)
data_Patho <- data_Patho[data_Patho$edad_Pacientes <= 120, ]


# Cigarros diarios del paciente
data_Patho$Número.de.cigarrillos.día <- as.numeric(substr(as.character(data_Patho$Número.de.cigarrillos.día), 1, 2))
data_Patho$Número.de.cigarrillos.día <- ifelse(is.na(data_Patho$Número.de.cigarrillos.día), 0, data_Patho$Número.de.cigarrillos.día)

# Valores de Alcohol
unique(data_Patho$Alcohol)

data_Patho$No_consumo <- ifelse(data_Patho$Alcohol == "No consumo", 1, 0)
data_Patho$Consumo_moderado <- ifelse(data_Patho$Alcohol == "Consumo moderado", 1, 0)
data_Patho$Consumo_elevado <- ifelse(data_Patho$Alcohol == "Consumo elevado", 1, 0)

# Elimino las filas que contengan NA y las que sobren
data_Patho = na.omit(data_Patho)
data_Patho <- data_Patho[, !(names(data_Patho) %in% c("Alcohol", "Fecha.de.Nacimiento",'respondent_id','Operador','Auxiliar','Jefe.de.Día'))]

data_Patho[data_Patho == ""] <- "No"

head(data_Patho)

data_Patho$Género <- ifelse(data_Patho$Género == "Mujer", 1, 0)

# Convertir otras variables a binario
variables_a_binario <- c("Patología.Sistémica", "Otras.Drogas","Medicación.Actual", "Tabaco..especificar.n..cigarrillos.en.caso.de.fumador.o.exfumador.", "Exfumador.a", "Fumador.a",
                         "Hipertensión.Arterial", "Hipercolesterolemia", "Insuficiencia.Cardíaca", "Angina.de.Pecho", "Infarto.de.Miocardio", "Arritmia",
                         "Accidente.Vascular.Cerebral", "Hipotensión.Arterial", "Anemia.Ferropénica", "Trastornos.Coagulación", "Trastornos.Agregación.Plaquetar",
                         "Úlcera.Gastroduodenal", "Gastritis", "Colitis", "Cirrosis", "Sinusitis", "Bronquitis", "Asma", "Insuficiencia.respiratoria",
                         "Vértigo", "Ansiedad", "Depresión", "Epilepsia", "Diabetes.I", "Diabetes.II", "Hipotiroidismo", "Hipertiroidismo", "Insuficiencia.renal",
                         "Litiasis.renal", "Diàlisis", "Artritis", "Artrosis", "Osteoporosis", "Gota", "Neoplasia", "Trasplante", "Quimioterapia", "Radioterapia",
                         "VIH", "Hepatitis", "Tuberculosis", "Otro..especifique.")

# Convertir las variables a binario
for (variable in variables_a_binario) {
  data_Patho[[variable]] <- ifelse(data_Patho[[variable]] == "No", 0, 1)
}

# Ver los primeros registros de los datos
head(data_Patho)

library(dplyr)

# Convertir todas las columnas a numérico
data_Patho <- data_Patho %>%
  mutate_all(as.numeric)

data_Patho <- data_Patho[, !(names(data_Patho) %in% c("Número.de.cigarrillos.día", "edad_Pacientes",
                                                      "Patología.Sistémica", "Medicación.Actual",
                                                      "No_consumo","Consumo_moderado","Género",
                                                      "Tabaco..especificar.n..cigarrillos.en.caso.de.fumador.o.exfumador.",
                                                      "Fumador.a"))]
library(factoextra)
library(factoextra)

# Supongamos que 'datos' es tu dataframe con las variables numéricas
# Seleccionar solo las variables numéricas si es necesario
# datos_numericos <- datos[, sapply(datos, is.numeric)]

# Realizar PCA
pca_resultado <- prcomp(data_Patho)

# Extraer los resultados
resultados <- pca_resultado$x  # Coordenadas de las observaciones
cargas <- pca_resultado$rotation  # Cargas de las variables
valores_propios <- pca_resultado$sdev^2  # Valores propios
proporcion_varianza_explicada <- pca_resultado$sdev^2 / sum(pca_resultado$sdev^2)  # Proporción de varianza explicada

# Resumen de los resultados
summary(pca_resultado)

# Visualización del PCA
fviz_pca_ind(pca_resultado, geom = "point", col.ind = "blue")

# Gráfico de las variables
fviz_pca_var(pca_resultado, col.var = "contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))
# Ordenar las variables por su contribución al primer componente principal
orden <- order(abs(pca_resultado$rotation[,1]), decreasing = TRUE)

# Seleccionar las 10 variables más importantes
top_10_variables <- orden[1:10]

# Gráfico de las 10 variables más importantes
fviz_pca_var(pca_resultado, col.var = "contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             axes = c(1, 2), choice = "var", 
             select.var = list(contrib = 10))














