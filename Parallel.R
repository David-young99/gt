library(doParallel)
library(foreach)

#GTM = file.path("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\GTM_R.R")
#SLV = file.path("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\SLV_R.R")
#HND = file.path("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\HND_R.R")
#NIC = file.path("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\NIC_R.R")
#CRI = file.path("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\CRI_R.R")
#PAN = file.path("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\PAN_R.R")

GTM = file.path("/home/dyoung/gitrepo/gt/GTM_R.R")
SLV = file.path("/home/dyoung/gitrepo/gt/SLV_R.R")
HND = file.path("/home/dyoung/gitrepo/gt/HND_R.R")
NIC = file.path("/home/dyoung/gitrepo/gt/NIC_R.R")
CRI = file.path("/home/dyoung/gitrepo/gt/CRI_R.R")
PAN = file.path("/home/dyoung/gitrepo/gt/PAN_R.R")

archivos = c(GTM, SLV, HND, NIC, CRI, PAN)


cl <- makeCluster(detectCores())
registerDoParallel(cl)


# Ejecutar los archivos en paralelo
resultados <- foreach(archivo = archivos, .combine = c) %dopar% {
  source(archivo)  # Ejecutar el archivo R
  # Puedes realizar otras operaciones con los resultados, como guardarlos en una lista
}

# Detener el backend de paralelismo
stopCluster(cl)