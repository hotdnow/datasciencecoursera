
# Exploratory Data Analysis
# May 2014


# Assignment 2


# Begin plot5.R


# Load the required library and read in the initial datasets

library(ggplot2)

NEI <- as.data.frame(readRDS('summarySCC_PM25.rds'))
SCC <- as.data.frame(readRDS('Source_Classification_Code.rds'))


# Using the 'grepl' function, search the entries in the 'EI.Sector' field that contain both of the 
# word 'mobile' and 'vehicle'.This will identify the rows conatining the mobile vehicle sources in 
# the dataframe. This logical variable is then applied to the rows of 'SCC' to only keep the rows we 
# in which we are interested.

SCC_log <- (grepl('[Mo]bile', SCC$EI.Sector)) & grepl('[Vv]ehicles', SCC$EI.Sector)

SCC_mobile <- SCC[SCC_log, ]


# Create a logical variable to identify the rows in the NEI dataframe related to Baltimore City.
# This logical variable is then applied to the rows of 'NEI' to only keep the rows we of NEI
# relating the Baltimore City. This application of the logical variable is done as part of the
# merge function below.
#
# After the merge, we have a dataframe containing rows of mobile vehicle info for Baltimore City

Balt_log <- NEI$fips == "24510"
SCC_NEI_mobile_Balt <- merge(NEI[Balt_log, ], SCC_mobile, by = 'SCC')


# USe the 'aggregate' function to sum the values in the 'Emissions' column by 'Year'
# and motor vehicle source. Then assign easy-to-read column names

ttl_PM_by_yr_mobile_Balt <- aggregate(SCC_NEI_mobile_Balt$Emissions, 
                                      by = list(SCC_NEI_mobile_Balt$year, SCC_NEI_mobile_Balt$EI.Sector), 
                                      FUN = 'sum', na.rm = TRUE)
colnames(ttl_PM_by_yr_mobile_Balt) <- c("Year", "Source", "Total.PM")


# Use the ggplot2 plotting system to create a panel of line graphs--separately by motor vehicle source.
# The graphs have 'Year' on the x-axis and PM2.5 emissions on the y-axis.
#
# The 'expression' function allows for the '2.5' to appear as subscripted text in the title
# and y-axis labels.
#
# Since the 'Year' variable is integer, the default x-axis labels were 2000, 2004, and 2008. This
# occurred since the ggplot2 plotting system tried to choose values that were spread out (and wouldn't
# overlap when printed). To get around that, in the 'aes( )' option I indicated that "Year" should be used
# as a character variable. Just making that change resulted in a warning as follows:
# 'geom_path: Each group consist of only one observation. Do you need to adjust the group aesthetic?'
# In order to address that, 'aes(group=Source)' needed to be added to the 'geom_line" and 'geom_point'
# expressions (to specify how the single observations should be grouped).

mobile_plot <- ggplot(ttl_PM_by_yr_mobile_Balt, aes(x=as.character(Year), y=Total.PM)) +
     
     geom_line(color = "black", size = 1, aes(group=Source)) + facet_wrap(~Source) + theme_bw() +
     
     geom_point(size = 3, color = "blue", aes(group=Source)) +
     
     labs(title = expression("PM"[2.5]*" Emissions - Motor Vehicles in Baltimore City")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in tons)"))

mobile_plot


# Print the plot to a ".png" file.

png(filename = "plot5.png", width = 560, height = 480)

mobile_plot <- ggplot(ttl_PM_by_yr_mobile_Balt, aes(x=as.character(Year), y=Total.PM)) +
     
     geom_line(color = "black", size = 1, aes(group=Source)) + facet_wrap(~Source) + theme_bw() +
     
     geom_point(size = 3, color = "blue",aes(group=Source)) +
     
     labs(title = expression("PM"[2.5]*" Emissions - Motor Vehicles in Baltimore City")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in tons)"))

mobile_plot

dev.off()
