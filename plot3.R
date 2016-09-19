url <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
currWd <- getwd()
tempFile <- paste0(currWd, '/file.zip')
download.file(url, destfile = tempFile, method = "curl")
unzip(tempFile)

setAs("character", "my-Date", function(from)
    as.Date(from, format = "%d/%m/%Y"))
setAs("character", "my-Time", function(from)
    strptime(from, format = "%H:%M:%S"))

powerConsumption <-
    read.csv(
        "household_power_consumption.txt",
        header = TRUE,
        sep = ";",
        na.strings = "?",
        colClasses = c("my-Date", "my-Time", rep("numeric", 7))
    )

powerConsumptionSubset1 <-
    subset(
        powerConsumption ,
        powerConsumption$Date == as.Date("01/02/2007", format = "%d/%m/%Y") |
            powerConsumption$Date == as.Date("02/02/2007", format = "%d/%m/%Y")
    )

date <- format(powerConsumptionSubset1$Date, format = "%d/%m/%Y")
time <- format(powerConsumptionSubset1$Time, format = "%H:%M:%S")
datetime <-
    strptime(paste(date, time), format = "%d/%m/%Y %H:%M:%S")

powerConsumptionSubset2 <- cbind(powerConsumptionSubset1, datetime)

png('plot3.png',  width = 480, height = 480)
plot(
    powerConsumptionSubset2$datetime,
    powerConsumptionSubset2$Sub_metering_1,
    type = 'l',
    ylab = 'Energy sub metering',
    xlab = '',
    ylim = range(c(0, 40)),
    col = 'black'
)
points(
    powerConsumptionSubset2$datetime,
    powerConsumptionSubset2$Sub_metering_2,
    type = 'l',
    col = 'red'
)
points(
    powerConsumptionSubset2$datetime,
    powerConsumptionSubset2$Sub_metering_3,
    type = 'l',
    col = 'blue'
)
legend(
    "topright",
    col = c("black", "red", "blue"),
    lty = c(1, 1, 1),
    legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
)
dev.off()
