# El primer paso es cargar los datos
data = read.csv('datos_Combinated.csv', sep=';')

# Vamos a fracionarlos en los distintos df
datos_Info_Pacientes = data[, 1:11]
head(datos_Info_Pacientes)

datos_Patologia_Sistemica = data[, 12:62]
head(datos_Patologia_Sistemica)

datos_Medicacion_Momento_Intervencion = data[, 63:113]
head(datos_Medicacion_Momento_Intervencion)

datos_Implantologia = data[, 114:902]
head(datos_Implantologia)

datos_Medicacion_Post_Intervencion = data[, 901:925]
head(datos_Medicacion_Post_Intervencion)

#::::::::::::: Cambio de valores:::::::::::::::::::::
# Genero
datos_Info_Pacientes$G.nero <- ifelse(datos_Info_Pacientes$G.nero == 1, "hombre", "mujer")

# Tipo de cirugia
datos_Implantologia$Tipo.de.Intervenci.n.Quir.rgica <- ifelse(datos_Implantologia$Tipo.de.Intervenci.n.Quir.rgica == 1, "Cirugía Dentoalveolar",
                                                        ifelse(datos_Implantologia$Tipo.de.Intervenci.n.Quir.rgica == 3, "Cirugía Peri-implantaria",
                                                        ifelse(datos_Implantologia$Tipo.de.Intervenci.n.Quir.rgica == 2, "Implantología Bucal", 
                                                                datos_Implantologia$Tipo.de.Intervenci.n.Quir.rgica)))
