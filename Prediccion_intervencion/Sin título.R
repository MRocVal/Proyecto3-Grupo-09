data = read.csv('data_clean.csv')



# Suponiendo que 'data' es tu conjunto de datos
# Eliminar cualquier fila con NA
data <- na.omit(data)

library(randomForest)
# Dividir los datos en conjuntos de entrenamiento y prueba (opcional)
set.seed(123)  # Establecer una semilla para reproducibilidad
indices_entrenamiento <- sample(1:nrow(data), round(0.8 * nrow(data)))
train <- data[indices_entrenamiento, ]
test <- data[-indices_entrenamiento, ]

# Entrenar el modelo de Random Forest
modelo_rf <- randomForest(duracion_intervencion ~ ., data = train, ntree = 100)

# Hacer predicciones en los datos de prueba
predicciones <- predict(modelo_rf, test)

# Calcular métricas de evaluación (opcional)
mse <- mean((predicciones - test$duracion_intervencion)^2)
r_squared <- cor(predicciones, test$duracion_intervencion)^2
#:__________________


