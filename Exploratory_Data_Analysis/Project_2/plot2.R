
# Exploratory Data Analysis
# May 2014


# Assignment 2


# Begin plot2.R


# Read in the initial datasets

NEI <- as.data.frame(readRDS('summarySCC_PM25.rds'))
SCC <- as.data.frame(readRDS('Source_Classification_Code.rds'))


# USe the 'aggregate' function to sum the values in the 'Emissions' column by 'Year' and
# 'fips'. Then assign easy-to-read column names

ttl_PM_by_year_and_fips <- aggregate(NEI$Emissions, 
                                     by = list(NEI$year, NEI$fips), 
                                     FUN = 'sum', na.rm = TRUE)
colnames(ttl_PM_by_year_and_fips) <- c("Year", "fips", "Total.PM")

# Set up a logical vector that will contain TRUEs wherever the entry in the 'fips' column
# equals '24510' (i.e. Baltimore City) and FALSEs otherwise.
# Apply that logical vector against the rows of the full dataframe to only keep those rows 
# from the larger dataframe that correspond to Baltimore city.  An alternative would have been
# to simpply use the 'subset' function.

fips_log <- ttl_PM_by_year_and_fips$fips == "24510"

ttl_PM_by_year_Balt <- ttl_PM_by_year_and_fips[fips_log, ]

# Use the base plotting system to create a line graph with 'Year' on the x-axis and 
# PM2.5 emissions on the y-axis
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


plot(ttl_PM_by_year_Balt$Year, (ttl_PM_by_year_Balt$Total.PM), type = "o", 
     xlab= "Year", 
     ylab = expression("PM"[2.5]*" Emissions (in tons)"), 
     main = expression("PM"[2.5]*" Emissions - Baltimore City"),
     xaxt="n",
     yaxt="n",
     pch = 19
)
axis(side = 1, at = seq(1999, 2008, by = 3))
axis(side = 2, at = seq(1800, 3600, by = 200), las = 2)


# Print the plot to a ".png" file.

png(filename = "plot2.png", width = 560, height = 480)

plot(ttl_PM_by_year_Balt$Year, (ttl_PM_by_year_Balt$Total.PM), type = "o", 
     xlab= "Year", 
     ylab = expression("PM"[2.5]*" Emissions (in tons)"), 
     main = expression("PM"[2.5]*" Emissions - Baltimore City"),
     xaxt="n",
     yaxt="n",
     pch = 19
)
axis(side = 1, at = seq(1999, 2008, by = 3))
axis(side = 2, at = seq(1800, 3600, by = 200), las = 2)

dev.off()

