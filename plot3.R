# Project 1 from coursera's Data Science Specialization: 4 - Exploratory Data Analysis course.
# Reconstruct Plot 3: Global Active Power (kilowatts) over the period of of time of two days of the three submeters (1: kitchen, 2: laundry room, 3: HVAC) in the same graph.
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
#here, we are using png() instead of dev.copy() used in plot1-2.R because the legend doesn't fit in the box: http://stackoverflow.com/questions/9400194/legend-truncated-when-saving-as-pdf-using-saveplot
png("plot3.png", width=480, height=480, units="px")

with(power2days, { #with is needed to define the dataframe to be used in the following instructions
    plot(Sub_metering_1 ~ Datetime, ylab = "Energy sub metering", xlab = "", type="l") #type L defines the graph as a line chart
    lines(Sub_metering_2 ~ Datetime, col = "Red") #lines() is needed to draw in the same area of the graph: https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/lines.html
    lines(Sub_metering_3 ~ Datetime, col = "Blue")
})
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("Black", "Red", "Blue"), lty = 1, lwd = 3) #https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/legend.html lty, lwd: the line types and widths for lines appearing in the legend. One of these two must be specified for line drawing.

#closing the graphics device
dev.off()
