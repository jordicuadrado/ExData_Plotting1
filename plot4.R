# Project 1 from coursera's Data Science Specialization: 4 - Exploratory Data Analysis course.
# Reconstruct Plot 4: Multiple plots in one device. Plots 2 and 3 stacked on the first column. Voltage over datetime in the upper right corner and Global Reactive Power (kvar) over datetime in the lower right corner.
# The code in this file is intended to be easily used in RStudio. One can construct a function to generate the PNG directly from the R terminal.
# Uses "household_power_consumption.txt" (133MB).

#setwd("~/Data Science Specialization/4 - Exploratory Data Analysis/Project 1/ExData_Plotting1")
archivoEntrada <- "household_power_consumption.txt"
handlerArchivo <- file(archivoEntrada) #opens the file handler to work directly with the "file stream"
#instead of read.table(archivoEntrada, header=TRUE, sep=";", na="?") we use a regexp in order to save memory by only reading the proper dates into the dataframe
#also, because of the regular expression we need to define the Column names (as we only have the data from the two dates and headers are gone)
power2days <- read.table(text = grep("^[1,2]/2/2007", readLines(handlerArchivo), value = TRUE), col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), header=TRUE, sep=";", na="?") #regex (grep) used to efficiently open and load the relevant data to memory
close(handlerArchivo)

#convert the Date and Time vars to a new merged Datetime class. Required because format YYYY-MM-DD is used in the assignment instructions. Also more useful to deal with datetimes.
datetime <- paste(as.Date(power2days$Date, "%d/%m/%Y"), power2days$Time)
power2days$Datetime <- as.POSIXct(datetime) #Also we can use something like power2days$dateTime <- strptime(paste(power2days$Date, power2days$Time), "%d/%m/%Y %H:%M:%S")

#construct the plot
png("plot4.png", width=480, height=480, units="px")

par(mfrow= c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0)) #define parameters: 2 rows, 2 cols, margins to be smaller than defaults, outter margin to be larger than the defaults
#the order to draw the graphs is from left to right, by rows:
# plot1 1st line(s) of code   plot2 2nd line(s) of code
# plot3 3rd line(s) of code   plot4 4th line(s) of code
with(power2days, { #needed to define the dataframe to be used in the following instructions
    plot(Global_active_power ~ Datetime, ylab="Global Active Power", xlab="", type="l")

    plot(Voltage ~ Datetime, ylab="Voltage", xlab = "datetime", type="l") #xlab used because by default it shows the name of the variable "Datetime" (note D in caps)

    plot(Sub_metering_1 ~ Datetime, ylab = "Energy sub metering", xlab = "", type="l") #type L defines the graph as a line chart
    lines(Sub_metering_2 ~ Datetime, col = "Red") #lines() is needed to draw in the same area of the graph: https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/lines.html
    lines(Sub_metering_3 ~ Datetime, col = "Blue")
    legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("Black", "Red", "Blue"), bty = "n", lty = 1, lwd = 3) #bty: the type of box to be drawn around the legend. The allowed values are "o" (the default) and "n". https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/legend.html

    plot(Global_reactive_power ~ Datetime, xlab = "datetime", type="l")
})

#closing the graphics device
dev.off()