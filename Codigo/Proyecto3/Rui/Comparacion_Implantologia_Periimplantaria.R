data = read.csv('combianted_Total.csv')

unique(data$Tipo_De_Intervencion_Quirurgica)

#::::::::::::::::::: Creacion de los dos conjuntos de datos:::::::::::::::::::::
library(dplyr)

datos_Implantologia_Bucal <- data %>%
  filter(data$Tipo_De_Intervencion_Quirurgica == "Implantologia Bucal")

#head(datos_Implantologia_Bucal)

datos_Periimplantaria <- data %>%
  filter(data$Tipo_De_Intervencion_Quirurgica == "Cirugía Peri-implantaria")


datos_Implantologia_Bucal <- datos_Implantologia_Bucal[, 1:57]
datos_Periimplantaria <- datos_Periimplantaria[, 1:57]
#head(datos_Periimplantaria)

#:::::::::::::::::: Limpieza y preparación :::::::::::::::::::::::::::::::::::::
library(dplyr)
datos_Implantologia_Bucal_p <- datos_Implantologia_Bucal %>%
  select_if(is.numeric)

datos_Periimplantaria_p <- datos_Periimplantaria %>%
  select_if(is.numeric)

# Asignar el ID del paciente como nombre de fila: IMPLANTOLOGIA
row.names(datos_Implantologia_Bucal_p) <- datos_Implantologia_Bucal_p$ID_Paciente

datos_Implantologia_Bucal_p <- datos_Implantologia_Bucal_p[, !colnames(datos_Implantologia_Bucal_p) %in% c("ID_Paciente","Cigarros.Diarios")]
rownames(datos_Implantologia_Bucal_p)

# Asignar el ID del paciente como nombre de fila: Periimplantitis
row.names(datos_Periimplantaria_p) <- datos_Periimplantaria_p$ID_Paciente

datos_Periimplantaria_p <- datos_Periimplantaria_p[, !colnames(datos_Periimplantaria_p) %in% c("ID_Paciente", "Cigarros.Diarios")]
rownames(datos_Periimplantaria_p)


#:::::::::::::::: PCA ::::::::::::::::::::::::::::::

#______________________IMPLANTOLOGIA_____________
library(factoextra)
library(cluster)

pca_result <- prcomp(datos_Implantologia_Bucal_p)

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
# Crear el biplot solo con las variables más importantes
fviz_pca_biplot(pca_result,
                col.ind = "cos2",
                select.var = list(contrib = 10),
                col.var = "contrib",
                repel = TRUE,
                ggtheme = theme_minimal()) +
  theme(legend.position = "right") +
  scale_color_gradient(low = "#00AFBB", high = "#E7B800") +  # Cambiar la escala de colores
  scale_shape_manual(values = c(1, 16))  # Cambiar la forma de los puntos

# Control variable colors using their contributions
fviz_pca_var(pca_result, 
             select.var = list(contrib = 10),
             col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)



fviz_pca_ind(pca_result,
             label = "none", # hide individual labels
             habillage = datos_Implantologia_Bucal$Genero, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, 
             ellipse.type = "confidence", # or "t", "norm", "euclid"
             repel = TRUE # to avoid overlapping labels
)


#______________________PeriImplantaria_____________

pca_result2 <- prcomp(datos_Periimplantaria_p)

# Visualiza la varianza explicada por cada componente principal
fviz_eig(pca_result2)
fviz_pca_ind(pca_result2,
             geom.ind = "point", 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,
             ggtheme = theme_minimal()) +
  theme(legend.position = "right")
# Gráfico de correlaciones entre variables y ejes principales
fviz_contrib(pca_result2, choice = "var", axes = 1:2, top = 10)

# Gráfico de correlaciones entre individuos y ejes principales
fviz_contrib(pca_result2, choice = "ind", axes = 1:2, top = 10)

# Biplot
# Crear el biplot solo con las variables más importantes
fviz_pca_biplot(pca_result2,
                col.ind = "cos2",
                select.var = list(contrib = 10), 
                col.var = "contrib",
                repel = TRUE,
                ggtheme = theme_minimal()) +
  theme(legend.position = "right") +
  scale_color_gradient(low = "#00AFBB", high = "#E7B800") +  # Cambiar la escala de colores
  scale_shape_manual(values = c(1, 16))  # Cambiar la forma de los puntos

# Control variable colors using their contributions
fviz_pca_var(pca_result2,
             select.var = list(contrib = 10), 
             col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)



fviz_pca_ind(pca_result2,
             label = "none", # hide individual labels
             habillage = datos_Periimplantaria$Genero, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, 
             ellipse.type = "confidence", # or "t", "norm", "euclid"
             repel = TRUE # to avoid overlapping labels
)






