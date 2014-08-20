## 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset to just Baltimore City, Maryland
BC <- subset(NEI, fips == "24510")
## create a dataframe with the aggregated sum for each year
emissions <- aggregate(BC$Emissions, by = list(BC$year), sum)
colnames(emissions) <- c("year", "emissions.sum")

##TODO: create png
##draw plot using the base plotting system.
with(emissions,
{
    plot(year, emissions.sum,
        main = "Total PM2 emissions over time for Baltimore City, Maryland",
        xlab="Year",
        ylab="Total PM2 emissions (tons)")
    ## Add a linear prediction line to show the tendency.
    model <- lm(emissions.sum ~ year, emissions)
    abline(model, lwd = 1)
})
## dev.off