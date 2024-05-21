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
data_Patho$edad_Pacientes <- as.integer(difftime(hoy, data_Patho$Fecha.de.Nacimiento, units = "days")/365)
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
data_Patho <- data_Patho[, !(names(data_Patho) %in% c("Alcohol", "Fecha.de.Nacimiento","Número.de.cigarrillos.día"))]

#::::::::::::::::::::::::::: Añadimos Variable Predictora
unique(data_g$Duración.de.la.intervención.quirúrgica)
data_g <- data_g[data_g$Duración.de.la.intervención.quirúrgica != "Response", ]

# Utiliza la función merge para unir los dataframes por la columna "respondent_id"
data_Patho <- merge(data_Patho, data_g[, c("respondent_id", "Duración.de.la.intervención.quirúrgica")], by = "respondent_id", all.x = TRUE)
names(data_Patho)[names(data_Patho) == "Duración.de.la.intervención.quirúrgica"] <- "Duracion_intervencion"

data_Patho$Duracion_intervencion <- ifelse(data_Patho$Duracion_intervencion == "0-5 minutos", 5,
                                       ifelse(data_Patho$Duracion_intervencion == "5-10 minutos", 10,
                                              ifelse(data_Patho$Duracion_intervencion == "10-20 minutos", 20,
                                                     ifelse(data_Patho$Duracion_intervencion == "20-40 minutos", 40,
                                                            ifelse(data_Patho$Duracion_intervencion == "40-60 minutos", 60,
                                                                   ifelse(data_Patho$Duracion_intervencion == "60-90 minutos", 90,
                                                                          ifelse(data_Patho$Duracion_intervencion == "90-120 minutos", 120,
                                                                                 ifelse(data_Patho$Duracion_intervencion == "120-180 minutos", 180,
                                                                                        ifelse(data_Patho$Duracion_intervencion == ">180 minutos", 200, NA)))))))))
data_Patho[data_Patho == ""] <- "No"

#::::::::::::::::::::: RANDOM FOREST
library(randomForest)

# Paso 1: Dividir los datos en conjuntos de entrenamiento y prueba
set.seed(123)  # Establece una semilla para reproducibilidad
porcentaje_entrenamiento <- 0.8  # Porcentaje de datos para entrenamiento
indices_entrenamiento <- sample(1:nrow(data_Patho), round(porcentaje_entrenamiento * nrow(data_Patho)))

train <- data_Patho[indices_entrenamiento, ]
train <- na.omit(train)
test <- data_Patho[-indices_entrenamiento, ]
test <- na.omit(test)

# Paso 2: Entrenar el modelo de Random Forest
modelo_rf <- randomForest( Duracion_intervencion~ ., data = train)

# Hacer predicciones con el modelo en los datos de prueba
predicciones <- predict(modelo_rf, test)

mse <- mean((predicciones - test$Duracion_intervencion)^2)
r_squared <- cor(predicciones, test$Duracion_intervencion)^2
