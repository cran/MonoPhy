\name{AssessMonophyly}
\alias{AssessMonophyly}
\title{
Assesses monophyly (or lack of it) of taxonomic groups in a phylogeny.
}
\description{
Requires rooted phylogeny as input and creates a table of taxa, their monophyly-status, which taxa cause problems in monophyly (as intruders or outliers) etc. Output can be accessed with related functions (see section 'see also') and a plot function can be used to plot the results in a number of ways.
}
\usage{
AssessMonophyly (tree, taxonomy=NULL, verbosity=5, outliercheck=TRUE,
outlierlevel=0.5, taxizelevel= NULL, taxizedb='ncbi', taxizepref='ncbi',
taxask=FALSE, taxverbose=FALSE)
}
\arguments{
  \item{tree}{
An object of type 'phy', a rooted phylogeny. Multifurcating trees are accepted, but will be dealt with in a conservative manner (i.e. if different taxa share a multifurcation, they will be considered non-monophyletic) If tip labels are in the format 'genus_species', the function can extract the genus names and check their monophyly. If tip labels are in another format or if the monophyly of other taxonomic groups should be tested, a taxonomy file (see 'taxonomy') is required.
}
  \item{taxonomy}{
A data frame (e.g. an imported .csv file) with at least two columns and one row per tip in the tree. If a header is specified, the names therein will be used in the function output. Column one contains the tip labels, column two and higher the names of the taxonomic units the respective tip belongs to. The order of tip names in the file can be different from the order of the tip labels in the tree, but they have to contain the exact same names. If taxonomic levels are unknown for certain tips, they can be coded as NAs (but they cannot stay empty). Those tips will be considered when assessing monophyly of other groups, but the monophyly of the NA group will not be assessed. Alternatively, specifying taxonomy as 'taxize' allows to use the package with the same name to download taxonomic names from online databases. Default is NULL.
}
  \item{verbosity}{
An integer, default is 5. Determines how many outlier/intruder taxa should be listed by name in the result table (it will list up to this many names and then add 'and X more').
}
  \item{outliercheck}{
If TRUE (default), the function will differenciate intruders or outliers as cause for non-monophyly. If the descendants of a taxon's MRCA contain less actual members of that taxon than specified under 'outlierlevel', the function will try to find a 'core clade', which is above this threshold. Taxon members outside of this core clade are then considered outliers and only the intruders within the core clade will actually be scored as intruders.
}
  \item{outlierlevel}{
If 'outliercheck' is set to TRUE, this argument defines the threshold for the outlier search. If a clade contains a fraction of actual taxon members that is lower than the fraction specified here, outliers will be defined. Enter a value between 0 and 1, default is 0.5.
}
  \item{taxizelevel}{
If taxonomy is set to 'taxize', it will download the taxonomic level specified here. Default is NULL.
}
  \item{taxizedb}{
If taxonomy is set to 'taxize', the desired taxonomic levels from the specified database. Either 'itis' or 'ncbi' or 'both'; is default is 'ncbi'. If 'both' is chosen, double entries will be discarded and the database result with did actually yeld an entry will be kept. Note that using 'both' can lead to conflicts within 'taxize'.
}
  \item{taxizepref}{
If taxonomy is set to 'taxize' and taxizedb to 'both', either 'itis' or 'ncbi' can be set to be preferred if both databases have records for the tip in question. Default is 'ncbi'.
}
  \item{taxask}{
If taxonomy is set to 'taxize', the called function 'tax_name' may find several potential matches in the queried databases. If 'taxask' is set to TRUE, the function will stop and prompt the user to pick an entry, if set to FALSE (which is default), it will pick the first entry and continue.
}
  \item{taxverbose}{
If taxonomy is set to 'taxize', the called function 'tax_name' can display the progress, i.e. the names that are being queried and the success of the query. The default for this is FALSE, in which case nothing will be displayed while querrying.
}
}
\details{
The function uses \code{\link[ape]{getMRCA}} from ape and \code{\link[phytools]{getDescendants}} from phytools to determine if a genus or other taxonomic group is monophyletic or not and subsets the two to determine which taxa cause non-monophyly. From the result object, different output items (see Values) can be accessed using a set of related functions and the result can be visualized using \code{\link{PlotMonophyly}}.
}
\value{
The output object of the function is a list containing the results as lists and data frames. If several taxonomic levels are analyzed, each will get a list-level containing its respective results. The different objects contained are:
  \item{IntruderTaxa }{List of the names of the taxonomic groups assessed to be non-monophyletic, each containing a character string with the names of the taxa which are intruders (i.e. interfere with the monophyly of that respective taxon). Can be accessed using \code{\link{GetIntruderTaxa}}.}
  \item{IntruderTips }{List of the names of the taxonomic groups assessed to be non-monophyletic, each containing a character string with the names of species/tips which are intruders (i.e. interfere with the monophyly of that taxon). Can be accessed using \code{\link{GetIntruderTips}}.}
  \item{OutlierTaxa }{Vector of the names of the taxonomic groups which were inferred to have outlier tips). Can be accessed using \code{\link{GetOutlierTaxa}}.}
  \item{OutlierTips }{List of the names of the taxonomic groups assessed to be non-monophyletic, each containing a character string with the names of species/tips which were inferred to be outliers (i.e. interfere with the monophyly of that taxon by being placed far from its core clade).  Can be accessed using \code{\link{GetOutlierTips}}.}
  \item{result }{Data frame containing the main results. Rows are the taxonomic groups used, columns are 'Monophyly' ('Yes', 'No' or 'Monotypic'), 'MRCA' (node number of inferred ancestor), '#Tips' (number of tips assigned to this taxon),'Delta-Tips' (number of tips which share this ancestral node but do not belong to the same taxon), '#Intruders'(how many other taxa interfere with the monophyly of the taxon in quesiton) and 'Intruders' (names of interfering taxa, how many of these are written out is determined by the argument 'verbosity'). If the argument outliercheck was set to TRUE when running 'AssessMonophyly', the table will additionally include '#Outliers' (number of tips which are placed outside the core clade for that group) and 'Outliers' (names of outlier taxa, the number of which also depending on the argument 'verbosity'). The whole data frame can be accessed using \code{\link{GetResultMonophyly}}, the MRCA nodes can be accessed using \code{\link{GetAncNodes}}.}
  \item{summary }{Data frame containing two rows with the number of taxa (e.g. genera) and tips (e.g. species) for the total tree, and which were inferred to be monophyletic, non-monophyletic, monotypic, intruders and (if applicable) outliers. Can be accessed using \code{\link{GetSummaryMonophyly}}.}
  \item{TipStates }{Data frame with the columns 'Tip', 'Taxon' and 'Status', containing the tip labels, their associated taxa and monophyly status (monophyletic, non-monophyletic, intruder or outlier) respectively. This data frame will be used by the function \code{\link{PlotMonophyly}}.}
}
\author{
Orlando Schwery
}
\seealso{
\code{\link{GetAncNodes}}, \code{\link{GetIntruderTaxa}}, \code{\link{GetIntruderTips}}, \code{\link{GetOutlierTaxa}}, \code{\link{GetOutlierTips}},\code{\link{GetResultMonophyly}}, \code{\link{GetSummaryMonophyly}}, \code{\link{MonophylyData}}, \code{\link{PlotMonophyly}}, \code{\link{MonoPhy-package}}
}
\examples{
data(Ericactree)  # load tree
solution <- AssessMonophyly(Ericactree)  # run analysis
GetSummaryMonophyly(solution)  # extract summary table from output

#use custom taxonomic level
data(Ericactree)  # load tree
data(Ericactribes)  # load taxonomy file
solutiontribes <- AssessMonophyly(Ericactree, taxonomy=Ericactribes)  # run analysis
GetSummaryMonophyly(solutiontribes)  # extract summary table from output
}
