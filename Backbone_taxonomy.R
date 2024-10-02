## COLLATING ARRAN DATA AND TAXONOMY CHECK

# First we will install and load the rgbif R package:
install.packages("rgbif")
library("rgbif")

#We will load the data into a variable named dat.messy:
  dat.messy <-
  read.csv("data/PaciFlora/Species_list_full_2905.csv",sep=";")

# bet a list of unique species name
  spp <- unique(dat.messy$species)
  spp <- spp[-which(is.na(spp))] ##remove na data
  spp <- spp[1:200] ##we will only use the 200 first species to be quicker
  n_spp <- length(spp) ##the number of species. Here it is obviously 200, but in practice you may not know.
  
# We can compare a species name to the GBIF backbone taxonomy using function name_backbone(). name_backbone() will generate a data frame
  spp.check.ok <- name_backbone("Felis catus",verbose=T,strict=T) 
  ##we initialize a data frame for a species that we are sure is in the backbone taxonomy: the cat.
  spp.check.ok <- spp.check.ok[-1,] ##we remove this row
  spp.check.bad <- name_backbone("xxx",verbose=T,strict=T) 
  ##weinitialize a data frame for a word that is not a species name.
  spp.check.bad <- spp.check.bad[-1,] ##we remove this row
  
# For all unique species names, we will check them against the GBIF backbone taxonomy, and keep the accepted species name if possible 

  ##prepare progress bar – this is just to see how far we are in the loop. This is useful for large databases
  pb <- txtProgressBar(min=0, max=n_spp, initial=0,style = 3)
  for(i in 1:n_spp){
    toto <- name_backbone(spp[i],verbose=T,strict=T) ##we check species I agains the GBIF backbone taxonomy
    if(length(which(names(toto)=="acceptedUsageKey"))==1){ ##if thereis a column "acceptedUsageKey", we remove it, as it will not be included for all species
      toto <- toto[,-which(names(toto)=="acceptedUsageKey")]
    }
    
    if(ncol(toto)==ncol(spp.check.ok)){ ##if there are 23 columns, the species name was recognised
      if(length(which(toto$status=="ACCEPTED"))>0){ ##is there a species name with status “ACCEPTED” in the returned data frame?
          spp.check.ok <-
            rbind(spp.check.ok,toto[which(toto$status=="ACCEPTED"),]) ##if so we only keep this name
      }else if(length(which(toto$status=="SYNONYM"))>0){ ##if there is no species name with status “ACCEPTED” in the returned data frame, is there a species name with status “SYNONYM” in the returned data frame?
          warning(paste("Species",spp[i],"is a synonmy")) ##we print a warning (this is optional)
        spp.check.ok <-
          rbind(spp.check.ok,toto[which(toto$status=="SYNONYM")[1],]) ##we only take the first one
      }else if(length(which(toto$status=="DOUBTFUL"))>0){ ##finally, is there a species name with status “DOUBTFUL” in the returned data frame?
          warning(paste("Species",spp[i],"is doubtful"))
        spp.check.ok <-
          rbind(spp.check.ok,toto[which(toto$status=="DOUBTFUL")[1],]) ##take the first one
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

# check if we have the same species appearing more than once: that would indicate that synonym were used in the database
  duplicated(spp.check.ok$canonicalName)
  
  length(which(spp.check.ok$status=="SYNONYM")) ##there are 17 species
  length(which(spp.check.ok$status=="DOUBTFUL")) ##there is no species
  spp.check.ok.syn <-
    spp.check.ok[which(spp.check.ok$status=="SYNONYM"),] ##let’s get the list of synonyms
  