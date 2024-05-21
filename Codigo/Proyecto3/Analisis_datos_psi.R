data = read.csv('Arreglo_datos/combianted_Total.csv')
data1 = read.csv('combined_dataframe_final.csv')

data1$Duración.de.la.intervención.quirúrgica
summary(data)



#_____________________Separación por tipo de dato___________________

# Patologias Sistemicas
datos_Patologia_Sistemica <- data[, 1:57]
head(datos_Patologia_Sistemica)

# Medicación en el momento de la intervención
datos_Medicacion_momento_intervencion <- data[, 59:110]
head(datos_Medicacion_momento_intervencion)

# Info de implantes y material quirurgico
datos_Implantologia_Cirugia <- data[, 111:905]
head(datos_Implantologia_Cirugia)

# Medicamentos suministrados post-Operatorio
datos_Medicacion_Pos_Operatorio <- data[, 905:930]
head(datos_Medicacion_Pos_Operatorio)

#______________________________________________________________________________

data$Duración.de.la.intervención.quirúrgica


datos_Patologia_Sistemica$TipoOperacion <- data$Tipo_De_Intervencion_Quirurgica
head(datos_Patologia_Sistemica)

# Transformamos a binario las categoricas
library(caret)


#______________________BINARIAS___________________
# Supongamos que deseas convertir varias columnas en un dataframe llamado datos_Patologia_Sistemica

# Lista de columnas que deseas convertir
columnas_a_convertir <- c("Alcohol", "Genero")

# Crear un modelo de dummy variables
modelo_dummy <- dummyVars(~ ., data = datos_Patologia_Sistemica[columnas_a_convertir], levelsOnly = TRUE)

# Aplicar el modelo para transformar las columnas
df <- predict(modelo_dummy, newdata = datos_Patologia_Sistemica[columnas_a_convertir])

# Unir las nuevas columnas al dataframe original
datos_Patologia_Sistemica <- cbind(datos_Patologia_Sistemica, df)

# Quitar las columnas originales si es necesario
datos_Patologia_Sistemica <- datos_Patologia_Sistemica[, !names(datos_Patologia_Sistemica) %in% columnas_a_convertir]

# Muestra el dataframe resultante
print(datos_Patologia_Sistemica)

#_____________________________________

#_____________________Calculo de la edad de los pacientes___________________

#_________________________________________

# Por ultimo, eliminamos las columnas que no vayamos a meter en el cluster
library(dplyr)

# Eliminar las columnas
datos_Patologia_Sistemica <- select(datos_Patologia_Sistemica, -Date_Create, -Fecha_intervencion, -Fecha_Nacimiento)
datos_Patologia_Sistemica


df = unique(datos_Patologia_Sistemica$TipoOperacion)
df = sum(datos_Patologia_Sistemica$TipoOperacion == 0)
df

# Suponiendo que tienes un dataframe llamado df
# Utiliza la indexación basada en filas para eliminar las filas con tipoOperacion igual a 0

datos_Patologia_Sistemica <- datos_Patologia_Sistemica[datos_Patologia_Sistemica$TipoOperacion != 0, ]
head(datos_Patologia_Sistemica)
#__________________-ANALISIS________________--
# Una vez preparados los datos, vamos con el cluster

# Instala y carga los paquetes necesarios
library(factoextra)
library(cluster)

# Realiza un análisis de componentes principales (PCA)

Pca_data = select(datos_Patologia_Sistemica, -TipoOperacion)
pca_result <- prcomp(Pca_data)

# Visualiza la varianza explicada por cada componente principal
fviz_eig(pca_result)
fviz_pca_ind(pca_result,
             geom.ind = "point", 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,
             ggtheme = theme_minimal()) +
  theme(legend.position = "right")
# Gráfico de correlaciones entre variables y ejes principales
fviz_contrib(pca_result, choice = "var", axes = 1:2, top = 10)

# Gráfico de correlaciones entre individuos y ejes principales
fviz_contrib(pca_result, choice = "ind", axes = 1:2, top = 10)

# Biplot
fviz_pca_biplot(pca_result,
                col.ind = "cos2", 
                col.var = "contrib",
                repel = TRUE,
                ggtheme = theme_minimal()) +
  theme(legend.position = "right")


# Selecciona el número óptimo de componentes principales (opcional)
# Puedes usar métodos como Criterio de Kaiser, Scree plot, o análisis de codo para esto

# Extrae las componentes principales que deseas utilizar para el clustering
# Por ejemplo, puedes seleccionar las primeras dos componentes principales
PC1 <- pca_result$x[,1]
PC2 <- pca_result$x[,2]

# Realiza el clustering usando k-means
num_clusters <- 3  # Define el número de clusters deseado
kmeans_result <- kmeans(cbind(PC1, PC2), centers = num_clusters)

# Visualiza los resultados del clustering
fviz_cluster(kmeans_result, data = cbind(PC1, PC2))

# Agrega las etiquetas de cluster al dataframe original
datos_Patologia_Sistemica$cluster <- kmeans_result$cluster

# Muestra el dataframe con las etiquetas de cluster
print(datos_Patologia_Sistemica)





#:::::::::::::::::::::::: CLUSTER ::::::::::::::::::::::::::::::::





