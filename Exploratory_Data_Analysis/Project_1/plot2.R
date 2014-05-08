# Exploratory Data Analysis
# May 2014

# Assignment 1


# Begin plot2.R


library(sqldf)
require ("sqldf")

myFile <- "household_power_consumption.txt"
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
wm <- as.data.frame(read.csv.sql(myFile, sql=mySql, sep=";"), na.strings = "?")
sqldf()

date_with_time <- paste(wm$Date, wm$Time)
wm$Day <- strptime(date_with_time, "%d/%m/%Y %H:%M:%S")

png(filename = "plot2.png", width = 480, height = 480)
plot(wm$Day, wm$Global_active_power, type = "l", 
     xlab= "", 
     ylab = "Global Active Power (kilowatts)"
)
dev.off()
