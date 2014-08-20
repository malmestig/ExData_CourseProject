## 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset to just Baltimore City, Maryland
BC<-subset(NEI, fips == "24510")
## create a dataframe with the aggregated sum for each year
emissions <- aggregate(BC$Emissions, by=list(BC$year, BC$type), sum)
colnames(emissions) <- c("year","type", "emissions.sum")

png(file = "plot3.png", width = 640, height = 480, bg = "white")
#draw plots using ggplot2
print(qplot(year, emissions.sum, data = emissions, size = I(3), facets = . ~ type) +
    ## Add a linear prediction line to show the tendency.
    stat_smooth(method="lm", se=FALSE) +
    labs(title = "Total emissions for Baltimore City per source type", x  = "Year", y ="Total PM25 emissions (tons)"))
dev.off()