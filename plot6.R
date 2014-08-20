## 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset to just Baltimore City (fips==24510) and Los Angeles (fips==06037)
BCLA <- subset(NEI, fips == "24510" | fips == "06037")

## The specification simply says motor vehicles without any distinction so I assume that grep-ing for "vehicle" will be a motor vehicle.
vehicles.all <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE),]

## Only the measurements that have an SCC in vehicles 
BCLA.vehicles <- BCLA[BCLA$SCC %in% vehicles.all$SCC,]
BCLA.vehicles$type <- factor(BCLA.vehicles$type)

## 
emissions <- aggregate(BCLA$Emissions, by=list(BCLA$year, BCLA$fips), sum)
colnames(emissions) <- c("year","location","emissions.sum")
## rewrite the location(old fips) column variables to something friendlier
emissions$location <- sapply(emissions$location, function(x) ifelse(x == "24510", "Baltimore City", "Los Angeles"))

# Set up some global options to customize the look of the plot.
options(scipen = 10)
png(file = "plot6.png", width = 640, height = 480, bg = "white")
#draw plot using ggplot2
print(qplot(year, emissions.sum, data = emissions, geom = "point", size = I(4), col = location) +
    ## Add a linear prediction line to show the tendency.
    stat_smooth(method="lm", se=FALSE) +
    labs(title = "Total motor vehicle emissions in Baltimore City vs Los Angeles", x  = "Year", y ="Total PM25 emissions (tons)"))
dev.off()