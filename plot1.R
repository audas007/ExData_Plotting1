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

png('plot1.png',  width = 480, height = 480)
hist(
    powerConsumptionSubset1$Global_active_power,
    main = 'Global Active Power',
    col = 'red',
    xlab = 'Global Active Power (kilowatts)'
)
dev.off()
