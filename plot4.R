## 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## First, reduce the dimension of the SCC dataframe by first grep-ing for all rows related to "coal" or "lignite" in the SCC.Level.Three variable. 
## then further narrow that down to only involve combustion by grep-ing for "combustion" in the SCC.Level.One variable 
coal.all <- SCC[grep("coal|lignite", SCC$SCC.Level.Three, ignore.case = TRUE),]
coal.combustion <- coal.all[grep("combustion", coal.all$SCC.Level.One, ignore.case = TRUE),]

## Only the rows that have an SCC in coal combustion 
NEI.coal.combustion <- NEI[NEI$SCC %in% coal.combustion$SCC,]

## aggregate the sum per year
emissions <- aggregate(NEI.coal.combustion$Emissions, by=list(NEI.coal.combustion$year), sum)
colnames(emissions) <- c("year","emissions.sum")

# Set up some global options to customize the look of the plot.
options(scipen = 10)
png(file = "plot4.png", width = 640, height = 480, bg = "white")
#draw plot using ggplot2
print(qplot(year, emissions.sum, data = emissions, geom = "point", size = I(4)) +
    ## Add a linear prediction line to show the tendency.
    stat_smooth(method="lm", se=FALSE) +
    labs(title = "Total coal combustion emissions across the United States", x  = "Year", y ="Total PM25 emissions (tons)"))
dev.off()