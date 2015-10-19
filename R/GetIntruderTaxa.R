#get list of intruders (genera) only displayed out of the outputlist of AssessMonophyly
# written by Orlando Schwery 2015

GetIntruderTaxa <-
function(solution, taxa=NULL, taxlevels='ALL') {
    alltaxa <- list()  # create empty list to be filled
    if (taxlevels != 'ALL' & class(taxlevels) != 'numeric') {  # test format of taxlevels argument and display error if format is wrong
	stop("taxlevels must be either 'ALL' or numeric!")
    }
    if (taxlevels == 'ALL') {  # if all taxlevels are looked for
        for (i in 1:length(solution)) {  # loop through all taxlevels
            nametax <- paste('Taxlevel', i, sep='_')  # create namelabel for current taxlevel
            if (length(taxa) == 0) {  # pick all if no taxon specified
                tmp <- solution[[i]]$IntruderTaxa  # extract sub-list of intruder taxa from solution
                alltaxa[[nametax]] <- tmp  # add extracted list as sub-object to output list and label it with the appropriate taxlevel nr.
            } else {  # display specific taxon if specified
                alltaxa2 <- list()  # create empty list to be filled
                for (itx in 1:length(taxa)) {  # loop to go through vector of taxon names
                    nametax2 <- taxa[itx]  # create label with name of invaded taxon first
                    tmp <- solution[[i]]$IntruderTaxa[[taxa[itx]]]  # extract invaders for this taxon from respective sub-object of solution
                    alltaxa2[[nametax2]] <- tmp  # add extracted invaders to output list, named after invaded taxon
                }
                alltaxa[[nametax]] <- alltaxa2  # add compiled invaders of this taxlevel as sub-list to outputlist, named after current taxlevel
            }
        }
    } else {  # if only a specific taxlevel is requested
        if (taxlevels > length(solution)) {  # test whether requested taxlevel is among available ones and display error if not
            stop('Requested taxonomic level not available (less levels specified as analysis input)!')
        }
		nametax <- paste('Taxlevel', taxlevels, sep='_')  # create namelabel for current taxlevel
		if (length(taxa) == 0) {  # pick all if no taxa specified
			tmp <- solution[[taxlevels]]$IntruderTaxa   # extract sub-list of intruder taxa from solution
            alltaxa[[nametax]] <- tmp  # add extracted list as sub-object to output list and label it with the appropriate taxlevel nr.
        } else {  # display specific taxa if requested
			alltaxa2 <- list()  # create empty list to be filled
            for (itx in 1:length(taxa)) {  # loop through vector of taxon names
                nametax2 <- taxa[i]  # create label with name of invaded taxon first
                tmp <- solution[[taxlevels]]$IntruderTaxa[[taxa[itx]]]  # extract invaders for this taxon from respective sub-object of solution
                alltaxa2[[nametax2]] <- tmp  # add extracted invaders to output list, named after invaded taxon
            }
            alltaxa[[nametax]] <- alltaxa2  # add compiled invaders of this taxlevel as sub-list to outputlist, named after current taxlevel
        }
    }
    alltaxa  # export output list
}