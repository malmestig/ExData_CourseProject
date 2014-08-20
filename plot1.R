## 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## This first line will likely take a few seconds. Be patient!
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

## create a dataframe with the aggregated sum for each year
emissions <- aggregate(NEI$Emissions, by=list(NEI$year), sum)
colnames(emissions) <- c("year", "emissions.sum")

# Set up some global options to customize the look of the plot.
options(scipen=10)
par(mar = c(4, 4, 2, 1), oma = c(2, 2, 2, 2))
png(file = "plot1.png", width = 640, height = 480, bg = "white")
##draw plot using the base plotting system.
with(emissions,
{
    plot(year, emissions.sum,
        main = "Total PM2 emissions over time across the United States",
        xlab="Year",
        ylab="Total PM2 emissions (tons)",
        pch = 20,
        cex = 2.5)
    ## Add a linear prediction line to show the tendency.
    model <- lm(emissions.sum ~ year, emissions)
    abline(model, lwd = 1, col = "blue")
})
dev.off()