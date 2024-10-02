rm(list=ls())
gc()
graphics.off()



############
library(rgbif)

dat.messy <- read.csv("PaciFlora/Species_list_full_2905.csv",sep=";")
spp <- unique(dat.messy$species)
spp <- spp[-which(is.na(spp))]
spp <- spp[1:200]
n_spp <- length(spp)

spp.check.ok <- name_backbone("Felis catus",verbose=T,strict=T)
spp.check.ok
spp.check.ok <- spp.check.ok[-1,]
spp.check.ok
spp.check.bad <- name_backbone("xxx",verbose=T,strict=T)
spp.check.bad
spp.check.bad <- spp.check.bad[-1,]
spp.check.bad

##prepare progress bar
pb <- txtProgressBar(min=0, max=n_spp, initial=0,style = 3)

for(i in 1:n_spp){
  toto <- name_backbone(spp[i],verbose=T,strict=T) ##we check species I agains the GBIF backbone taxonomy
  if(length(which(names(toto)=="acceptedUsageKey"))==1){ ##if there is a column "acceptedUsageKey", we remove it, as it will not be included for all species
    toto <- toto[,-which(names(toto)=="acceptedUsageKey")]
  }
  if(ncol(toto)==ncol(spp.check.ok)){ ##if there are 23 columns, the species name was recognised
    if(length(which(toto$status=="ACCEPTED"))>0){ ##is there a species name with status “ACCEPTED” in the returned data frame?
      spp.check.ok <- rbind(spp.check.ok,toto[which(toto$status=="ACCEPTED"),]) ##if so we only keep this name
    }else if(length(which(toto$status=="SYNONYM"))>0){ ##if there is no species name with status “ACCEPTED” in the returned data frame, is there a species name with status “SYNONYM” in the returned data frame?
      warning(paste("Species",spp[i],"is a synonmy")) ##we print a warning (this is optional)
      spp.check.ok <- rbind(spp.check.ok,toto[which(toto$status=="SYNONYM")[1],]) ##we only take the first one
    }else if(length(which(toto$status=="DOUBTFUL"))>0){ ##finally, is there a species name with status “DOUBTFUL” in the returned data frame?
      warning(paste("Species",spp[i],"is doubtful"))
      spp.check.ok <- rbind(spp.check.ok,toto[which(toto$status=="DOUBTFUL")[1],]) ##take the first one
    }else{
      stop("Status unknown") ##the status is neither "ACCEPTED", "SYNONYM" nor "DOUBTFUL" – it should not happen, but better to check
    }   
  }else if(ncol(toto)==ncol(spp.check.bad)){
    spp.check.bad <- rbind(spp.check.bad,toto)
  }
  else{
    stop("Unknown length") ## if we have a data frame with a different size, we want to check why
  }
  info <- sprintf("%d%% done", round((i/n_spp)*100)) ##update the progress bar
  setTxtProgressBar(pb, i, label=info)
}
close(pb)

duplicated(spp.check.ok$canonicalName)
length(which(spp.check.ok$status=="SYNONYM"))
length(which(spp.check.ok$status=="DOUBTFUL"))

spp.check.ok.syn <- spp.check.ok[which(spp.check.ok$status=="SYNONYM"),] ##let’s get the list of synonyms
spp.check.ok.syn

length(which(spp.check.ok$rank=="GENUS"))
spp[which(spp.check.ok$rank=="GENUS")]

name_backbone("Desmodium triflorum")
name_backbone("Cyperus involucratus")
