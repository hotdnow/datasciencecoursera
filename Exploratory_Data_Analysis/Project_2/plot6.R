
# Exploratory Data Analysis
# May 2014


# Assignment 2


# Begin plot6.R


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


# Create two logical variables to identify the rows in the NEI dataframe related to Baltimore City and
# Los Angeles, resp. These logical variables are then applied to the rows of 'NEI' to only keep the 
# rows we of NEI relating to these two cities. This application of the logical variables is done as part
# of the two merges below.
#
# After the merge, we have two dataframe, the first containing rows of mobile vehicle info for 
# Baltimore City and the second one for Los Angeles. Rather than keep the 'fips' code for the cities
# I replaced the code with the actual city's text label. Since the entries in this field are used by
# gglplot2 at the headings on graph, I wanted the heading to say "Baltimore" rather than "24510".

Balt_log <- NEI$fips == "24510"
LA_log <- NEI$fips == "06037"

SCC_NEI_mobile_Balt <- merge(NEI[Balt_log, ], SCC_mobile, by = 'SCC')
SCC_NEI_mobile_Balt$fips <- "Baltimore"

SCC_NEI_mobile_LA <- merge(NEI[LA_log, ], SCC_mobile, by = 'SCC')
SCC_NEI_mobile_LA$fips <- "Los.Angeles"


# After the two merges, I used 'rbind' to put the rows of the Baltimore dataframe on top of the one
# for Los Angeles--creating one dataframe to feed into the 'aggregate' function.

Balt_and_LA <- rbind(SCC_NEI_mobile_Balt, SCC_NEI_mobile_LA)


# USe the 'aggregate' function to sum the values in the 'Emissions' column by 'Year'
# and city (i.e. 'fips' code).Then assign easy-to-read column names.

ttl_PM_by_yr_mobile_Balt_LA <- aggregate(Balt_and_LA$Emissions, 
                                         by = list(Balt_and_LA$year, Balt_and_LA$fips), 
                                         FUN = 'sum', na.rm = TRUE)
colnames(ttl_PM_by_yr_mobile_Balt_LA) <- c("Year", "fips", "Total.PM")


# Use the ggplot2 plotting system to create a bar charts, separated by city.
# The graphs have 'Year' on the x-axis and PM2.5 emissions on the y-axis.
#
# The 'expression' function allows for the '2.5' to appear as subscripted text in the title
# and y-axis labels.
#
# The 'position=position_dodge()' option allows the two bars in each group not to overlap
# To create a larger plot, I also moved the legend to the bottom of the graph

Balt_LA_plot <- ggplot(ttl_PM_by_yr_mobile_Balt_LA, aes(x=as.character(Year), y=Total.PM)) +
     
     geom_bar(size = 1, aes(group=fips, fill=fips), stat="identity", position=position_dodge() ) + theme_bw() +
     
     labs(title = expression("PM"[2.5]*" Emissions - Motor Vehicle Sources")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in tons)")) +
     
     theme(legend.position="bottom", legend.title=element_blank())

Balt_LA_plot


# Print the plot to a ".png" file.

png(filename = "plot6.png", width = 560, height = 480)

Balt_LA_plot <- ggplot(ttl_PM_by_yr_mobile_Balt_LA, aes(x=as.character(Year), y=Total.PM)) +
     
     geom_bar(size = 1, aes(group=fips, fill=fips), stat="identity", position=position_dodge() ) + theme_bw() +
     
     labs(title = expression("PM"[2.5]*" Emissions - Motor Vehicle Sources")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in tons)")) +
     
     theme(legend.position="bottom", legend.title=element_blank())

Balt_LA_plot

dev.off()
