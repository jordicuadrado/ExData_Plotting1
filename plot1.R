# Project 1 from coursera's Data Science Specialization: 4 - Exploratory Data Analysis course.
# Reconstruct Plot 1: A histogram of Global Active Power (kW) vs Frequency (useful to asses peak power or how much power was needed over a period of time)
# The code in this file is intended to be easily used in RStudio. One can construct a function to generate the PNG directly from the R terminal.
# Uses "household_power_consumption.txt" (133MB).

#setwd("~/Data Science Specialization/4 - Exploratory Data Analysis/Project 1/ExData_Plotting1")
archivoEntrada <- "household_power_consumption.txt"
handlerArchivo <- file(archivoEntrada) #opens the file handler to work directly with the "file stream"
#instead of read.table(archivoEntrada, header=TRUE, sep=";", na="?") we use a regexp in order to save memory by only reading the proper dates into the dataframe
#also, because of the regular expression we need to define the Column names (as we only have the data from the two dates and headers are gone)
power2days <- read.table(text = grep("^[1,2]/2/2007", readLines(handlerArchivo), value = TRUE), col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), header=TRUE, sep=";", na="?") #regex (grep) used to efficiently open and load the relevant data to memory
close(handlerArchivo)

#convert the Date and Time vars to a new merged Datetime class (datetime required in Plot 4). Required because format YYYY-MM-DD is used in the assignment instructions. Also more useful to deal with datetimes.
datetime <- paste(as.Date(power2days$Date, "%d/%m/%Y"), power2days$Time)
power2days$Datetime <- as.POSIXct(datetime) #Also we can use something like power2days$dateTime <- strptime(paste(power2days$Date, power2days$Time), "%d/%m/%Y %H:%M:%S")

#construct the plot
hist(power2days$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", col="red")

#save it to a PNG file with a width of 480 pixels and a height of 480 pixels. Name each of the plot files as plot1.png
dev.copy(png, file="plot1.png", width=480, height=480) #also we can use png() before calling hist() to generate the PNG
dev.off()
