#:::::::::::::::::::::::::::::::::::::Lectura de datos
data = read.csv('AFC/nuevo_df.csv')

# Breve exploración
summary(data)

# A caraceter las numericas
# Lista de todas las variables que deseas convertir a tipo de dato "carácter"
variables <- c("Medicación.Actual", "Alcohol", "Otras.Drogas", "Tuberculosis", 
               "Nitratos.orgánicos", "Hormonas.pancreáticas", "Antitusígenos", 
               "Fármacos.otológicos")
# Convertir todas las variables a tipo de dato "carácter"
data[variables] <- lapply(data[variables], as.character)

summary(data)

# :::::::::::::::::::::::::::::::::::::Discretización de la variable Duración intervención.

# Cambiar el nombre de la columna
names(data)[names(data) == "Duración.de.la.intervención.quirúrgica"] <- "duracion_intervencion"

# Definir la función para mapear los rangos de tiempo a valores numéricos
mapeo_rangos <- function(tiempo) {
  if (tiempo == "0-5 minutos") return(2.5)
  if (tiempo == "5-10 minutos") return(7.5)
  if (tiempo == "10-20 minutos") return(15)
  if (tiempo == "20-40 minutos") return(30)
  if (tiempo == "40-60 minutos") return(50)
  if (tiempo == "60-90 minutos") return(75)
  if (tiempo == "90-120 minutos") return(105)
  if (tiempo == "120-180 minutos") return(150)
  if (tiempo == ">180 minutos") return(200)
  return(NA)  # Valor por defecto si no coincide con ninguno de los rangos
}

# Aplicar la función a la columna duracion_intervencion
data$duracion_intervencion <- sapply(data$duracion_intervencion, mapeo_rangos)



# Calcular la media de la variable Duración.de.la.intervención.quirúrgica
media <- mean(data$duracion_intervencion, na.rm = TRUE)

# Sustituir los valores NA por la media
data$duracion_intervencion[is.na(data$duracion_intervencion)] <- media

data <- na.omit(data)

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::  RandomForest
library(randomForest)

# Paso 1: Dividir los datos en conjuntos de entrenamiento y prueba
set.seed(123)  # Establece una semilla para reproducibilidad
porcentaje_entrenamiento <- 0.8  # Porcentaje de datos para entrenamiento
indices_entrenamiento <- sample(1:nrow(data), round(porcentaje_entrenamiento * nrow(data)))

train <- data[indices_entrenamiento, ]
train <- na.omit(train)
test <- data[-indices_entrenamiento, ]
test <- na.omit(test)

# Entrenar un modelo con hiperparámetros específicos
modelo_rf <- randomForest(duracion_intervencion ~ ., data = train, 
                          ntree = 100, mtry = 3)

# Hacer predicciones en los datos de prueba
predicciones <- predict(modelo_rf, test)

# Calcular el error cuadrático medio y R-cuadrado
mse <- mean((predicciones - test$duracion_intervencion)^2)
r_squared <- cor(predicciones, test$duracion_intervencion)^2

# Crear un nuevo dataframe con dos columnas
nuevo_df <- data.frame(duracion_intervencion = test$duracion_intervencion, 
                       predicciones = predicciones)

# Ver el rendimiento del modelo
print(paste("Error cuadrático medio:", mse))
print(paste("R-cuadrado:", r_squared))





#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#:::::::::::::: GRANDIENT

# Instala y carga el paquete 'caret' para manejo de datos

library(caret)

# Codificar variables categóricas utilizando one-hot encoding
train_encoded <- dummyVars(~ ., data = train)
train_encoded <- predict(train_encoded, newdata = train)
# Convertir la matriz train_encoded a data frame
train_encoded_df <- as.data.frame(train_encoded)

# Ajustar el modelo de regresión lineal
modelo_regresion <- lm(duracion_intervencion ~ ., data = train_encoded_df)

# Predicciones en el conjunto de datos de entrenamiento
train_predicted <- predict(modelo_regresion, newdata = train_encoded_df)

# Predicciones en el conjunto de datos de prueba (reemplaza 'test' con tu conjunto de datos de prueba)
# test_encoded <- dummyVars(~ ., data = test)
# test_encoded <- predict(test_encoded, newdata = test)
# test_encoded_df <- as.data.frame(test_encoded)
# test_predicted <- predict(modelo_regresion, newdata = test_encoded_df)

# Coeficiente de determinación (R-cuadrado)
r_squared <- summary(modelo_regresion)$r.squared

# Error estándar residual
residual_std_error <- summary(modelo_regresion)$sigma

# Significancia de los coeficientes (p-values)
p_values <- summary(modelo_regresion)$coefficients[, 4]

# Residuos
residuals <- residuals(modelo_regresion)


library(boot)
# Validación cruzada (ejemplo de validación cruzada de 10 veces)
set.seed(123) # Para reproducibilidad
cv <- cv.glm(data = train_encoded_df, glmfit = modelo_regresion, K = )
cv_error <- cv$delta[1]



# Gráficos de diagnóstico (ejemplo de gráfico de dispersión de valores observados vs. predichos)
plot(train_encoded_df$duracion_intervencion, train_predicted,
     xlab = "Valores Observados", ylab = "Valores Predichos",
     main = "Valores Observados vs. Valores Predichos")
abline(0, 1, col = "red") # Agrega una línea de referencia
