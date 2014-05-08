
# Exploratory Data Analysis
# May 2014


# Assignment 1


# Begin plot3.R


library(sqldf)
require ("sqldf")

myFile <- "household_power_consumption.txt"
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
#wm <- as.data.frame(read.csv.sql(myFile, sql=mySql, sep=";"))
wm <- as.data.frame(read.csv.sql(myFile, sql=mySql, sep=";"), na.strings = "?")
sqldf()

date_with_time <- paste(wm$Date, wm$Time)
wm$Day <- strptime(date_with_time, "%d/%m/%Y %H:%M:%S")

png(filename = "plot3.png", width = 480, height = 480)

plot(wm$Day, wm$Sub_metering_1, 
     col = "gray",
     xlab ="",
     ylab = "Energy sub metering",
     type = "l")

lines(wm$Day, wm$Sub_metering_2, col = "red")
lines(wm$Day, wm$Sub_metering_3, col = "blue")
legend("topright", pch = "_", col=c("gray", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()

