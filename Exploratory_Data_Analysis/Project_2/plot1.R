
# Exploratory Data Analysis
# May 2014


# Assignment 2



# Begin plot1.R


# Read in the initial datasets

NEI <- as.data.frame(readRDS('summarySCC_PM25.rds'))
SCC <- as.data.frame(readRDS('Source_Classification_Code.rds'))

# USe the 'aggregate' function to sum the values in the 'Emissions' column by 'Year'
# and then assign easy-to-read column names

ttl_PM_by_year <- aggregate(NEI$Emissions, 
                            by = list(NEI$year), 
                            FUN = 'sum', na.rm = TRUE)
colnames(ttl_PM_by_year) <- c("Year", "Total.PM")

# Use the base plotting system to create a line graph with 'Year' on the x-axis and 
# PM2.5 emissions (graphed in millions) on the y-axis
#
# The 'expression' function allows for the '2.5' to appear as subscripted text in the title
# and y-axis labels.
#
# Since the 'Year' variable is integer, the default x-axis labels were 2000, 2004, and 2008. This
# occurred since the base plotting system tried to choose values that were spread out (and wouldn't
# overlap when printed). To get around that, I suppressed the printing of the x- and y-axis labels
# with the xant = 'n' and yant = 'n' lines. Then through the 'axis' lines, a specified the values 
# that should appear on the x-axis.The labeling of the data values was accomplished through the 
# 'text' parameter settings.

plot(ttl_PM_by_year$Year, (ttl_PM_by_year$Total.PM)/1000000, type = "o", 
     xlab= "Year", 
     ylab = expression("PM"[2.5]*" Emissions (in millions of tons)"), 
     main = expression("Unites States PM"[2.5]*" Emissions"),
     xaxt="n",
     yaxt="n",
     ylim = c(3, 8),
     pch = 19     
)
axis(side = 1, at = seq(1999, 2008, by = 3))
axis(side = 2, las = 2)

text(x=ttl_PM_by_year$Year, 
     y=(ttl_PM_by_year$Total.PM)/1000000, 
     labels=paste("  ",round((ttl_PM_by_year$Total.PM)/1000000,1),"M"),
     pos = 3,
     cex = 0.8
)

# Print the plot to a ".png" file.

png(filename = "plot1.png", width = 560, height = 480)

plot(ttl_PM_by_year$Year, (ttl_PM_by_year$Total.PM)/1000000, type = "o", 
     xlab= "Year", 
     ylab = expression("PM"[2.5]*" Emissions (in millions of tons)"), 
     main = expression("Unites States PM"[2.5]*" Emissions"),
     xaxt="n",
     yaxt="n",
     ylim = c(3, 8),
     pch = 19     
)
axis(side = 1, at = seq(1999, 2008, by = 3))
axis(side = 2, las = 2)

text(x=ttl_PM_by_year$Year, 
     y=(ttl_PM_by_year$Total.PM)/1000000, 
     labels=paste("  ",round((ttl_PM_by_year$Total.PM)/1000000,1),"M"),
     pos = 3,
     cex = 0.8
)

dev.off()