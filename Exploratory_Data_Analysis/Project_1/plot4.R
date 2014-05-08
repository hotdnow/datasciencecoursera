
# Exploratory Data Analysis
# May 2014


# Assignment 1


# Begin plot4.R

library(sqldf)
require ("sqldf")

myFile <- "household_power_consumption.txt"
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
wm <- as.data.frame(read.csv.sql(myFile, sql=mySql, sep=";"), na.strings = "?")
sqldf()

date_with_time <- paste(wm$Date, wm$Time)
wm$Day <- strptime(date_with_time, "%d/%m/%Y %H:%M:%S")


png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2,2))

plot(wm$Day, wm$Global_active_power, type = "l", 
     xlab= "", 
     ylab = "Global Active Power"
)


plot(wm$Day, wm$Voltage, type = "l", 
     xlab= "datetime", 
     ylab = "Voltage"
)


plot(wm$Day, wm$Sub_metering_1, 
     col = "gray",
     xlab ="",
     ylab = "Energy sub metering",
     type = "l")

lines(wm$Day, wm$Sub_metering_2, col = "red")
lines(wm$Day, wm$Sub_metering_3, col = "blue")
legend("topright", bty = "n", pch = "_", col=c("gray", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))



plot(wm$Day, wm$Global_reactive_power, type = "l", 
     xlab= "datetime", 
     ylab = "Global_reactive_power"
)

dev.off()

