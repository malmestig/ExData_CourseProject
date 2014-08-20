## 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset to just Baltimore City
BC <- subset(NEI, fips == "24510")

## The specification simply says motor vehicles without any distinction so I assume that grep-ing for "vehicle" will be a motor vehicle.
vehicles.all <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE),]

# Only the measurements that have an SCC in vehicles
BC.vehicles <- BC[BC$SCC %in% vehicles.all$SCC,]

## aggregate the sum per year
emissions <- aggregate(BC.vehicles$Emissions, by=list(BC.vehicles$year), sum)
colnames(emissions) <- c("year","emissions.sum")

png(file = "plot5.png", width = 640, height = 480, bg = "white")
#draw plot using ggplot2
print(qplot(year, emissions.sum, data = emissions, geom = "point", size = I(4)) +
    ## Add a linear prediction line to show the tendency.
    stat_smooth(method="lm", se=FALSE) +
    labs(title = "Total motor vehicle emissions in Baltimore City", x  = "Year", y ="Total PM25 emissions (tons)"))
dev.off()