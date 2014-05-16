
# Exploratory Data Analysis
# May 2014


# Assignment 2


# Begin plot4.R


# Load the required library and read in the initial datasets

library(ggplot2)

NEI <- as.data.frame(readRDS('summarySCC_PM25.rds'))
SCC <- as.data.frame(readRDS('Source_Classification_Code.rds'))


# Using the 'grepl' function, search the entries in the 'EI.Sector' field for the word 'coal'.
# This will identify the rows conatining the coal combustion-related sources in the dataframe.
# This logical variable is then applied to the rows of 'SCC' to only keep the rows we in which 
# we are interested.

SCC_log <- grepl('[Cc]oal', SCC$EI.Sector)

SCC_coal <- SCC[SCC_log, ]


# Merge the large NEI dataframe with the pared-down SCC dataframe by the common 'SCC' field. This
# results in a subsetted NEI dataframe which only contains the coal-related rows.

SCC_NEI_coal <- merge(NEI, SCC_coal, by = 'SCC')


# USe the 'aggregate' function to sum the values in the 'Emissions' column by 'Year'
# and coal combustion source. Then assign easy-to-read column names

ttl_PM_by_yr_coal <- aggregate(SCC_NEI_coal$Emissions, 
                               by = list(SCC_NEI_coal$year, SCC_NEI_coal$EI.Sector), 
                               FUN = 'sum', na.rm = TRUE)
colnames(ttl_PM_by_yr_coal) <- c("Year", "Source", "Total.PM")

# Use the ggplot2 plotting system to a bar chart--separated by coal combusiton source and year.
# The graphs have 'Year' on the x-axis and PM2.5 emissions (in thousands) on the y-axis.
#
# The 'expression' function allows for the '2.5' to appear as subscripted text in the title
# and y-axis labels.
#
# The 'position=position_dodge()' option allows the three bars in each group not to overlap
# To create a larger plot, I also moved the legend inside the graph
#
# Additional (although no longer being used) code is also provided below that allows a panel
# of lines graphs (one for each 'source') to be produced 


coal_plot <- ggplot(ttl_PM_by_yr_coal, aes(x=as.character(Year), y=Total.PM/1000)) +
     
     geom_bar(size = 1, aes(group=Source, fill=Source), stat="identity", position=position_dodge() ) + theme_bw() +
     
     #     geom_line(color = "black", size = 1, aes(group=Source)) + facet_wrap(~Source, nrow = 1, ncol = 3) + theme_bw() +
     #     geom_point(size = 3, color = "blue",aes(group=Source)) +
     
     ylim(0,650) +
     
     labs(title = expression("United States PM"[2.5]*" Emissions - Coal-related Sources")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in '000s of tons)")) +
     
     theme(legend.justification=c(1,0), legend.position=c(1,.75), legend.title=element_blank())

coal_plot


# Print the plot to a ".png" file.

png(filename = "plot4.png", width = 560, height = 480)

coal_plot <- ggplot(ttl_PM_by_yr_coal, aes(x=as.character(Year), y=Total.PM/1000)) +
     
     geom_bar(size = 1, aes(group=Source, fill=Source), stat="identity", position=position_dodge() ) + theme_bw() +
     
     ylim(0,650) +
     
     labs(title = expression("United States PM"[2.5]*" Emissions - Coal-related Sources")) +
     
     labs(x = "Year") + 
     
     labs(y = expression("Total PM"[2.5]*" Emissions (in '000s of tons)")) +
     
     theme(legend.justification=c(1,0), legend.position=c(1,.75), legend.title=element_blank())

coal_plot

dev.off()
