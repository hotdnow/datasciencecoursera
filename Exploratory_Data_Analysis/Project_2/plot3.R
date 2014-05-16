
# Exploratory Data Analysis
# May 2014


# Assignment 2



# Begin plot3.R


# Load the required library and read in the initial datasets

library(ggplot2)

NEI <- as.data.frame(readRDS('summarySCC_PM25.rds'))
SCC <- as.data.frame(readRDS('Source_Classification_Code.rds'))


# USe the 'aggregate' function to sum the values in the 'Emissions' column by 'Year', 
# 'fips', and 'type'. Then assign easy-to-read column names

ttl_PM_by_yr_fips_type <- aggregate(NEI$Emissions, 
                                    by = list(NEI$year, NEI$fips, NEI$type), 
                                    FUN = 'sum', na.rm = TRUE)
colnames(ttl_PM_by_yr_fips_type) <- c("Year", "fips", "Type", "Total.PM")

# Set up a logical vector that will contain TRUEs wherever the entry in the 'fips' column
# equals '24510' (i.e. Baltimore City) and FALSEs otherwise.
# Apply that logical vector against the rows of the full dataframe to only keep those rows 
# from the larger dataframe that correspond to Baltimore city.  An alternative would have been
# to simpply use the 'subset' function.

yr_type_Balt_log <- ttl_PM_by_yr_fips_type$fips == "24510"

ttl_PM_by_yr_type_Balt <- ttl_PM_by_yr_fips_type[yr_type_Balt_log, ]

# Use the ggplot2 plotting system to create a panel of four line graphs--one corresponding to each
# 'type' variable. The graphs have 'Year' on the x-axis and PM2.5 emissions on the y-axis.
#
# The 'expression' function allows for the '2.5' to appear as subscripted text in the title
# and y-axis labels.

balt_plot <- ggplot(ttl_PM_by_yr_type_Balt, aes(x=Year, y=Total.PM)) +
     
     geom_line(color = "black", size = 1) + facet_wrap(~ Type) + theme_bw() +
     
     geom_point(size = 3, color = "blue") +
     
     labs(title = expression("Total PM"[2.5]*" Emissions - Baltimore City")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in tons)"))   

balt_plot


# Print the plot to a ".png" file.

png(filename = "plot3.png", width = 560, height = 480)

balt_plot <- ggplot(ttl_PM_by_yr_type_Balt, aes(x=Year, y=Total.PM)) +
     
     geom_line(color = "black", size = 1) + facet_wrap(~ Type) + theme_bw() +
     
     geom_point(size = 3, color = "blue") +
     
     labs(title = expression("Total PM"[2.5]*" Emissions - Baltimore City")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in tons)"))   

balt_plot

dev.off()
