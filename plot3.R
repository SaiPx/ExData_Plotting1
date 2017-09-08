library(data.table)
library(dplyr)

## Download data file to local folder and unzip contents
if (!file.exists("exdata%2Fdata%2Fhousehold_power_consumption.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile = "exdata%2Fdata%2Fhousehold_power_consumption.zip", mode="wb"
  )
  dateDownloaded <- date()
  
  unzip(zipfile="exdata%2Fdata%2Fhousehold_power_consumption.zip", exdir="./data")
}

## Load the input data file
globalPow<-read.table("./data/household_power_consumption.txt",skip=1,sep=";")

## Set Column names as provided in the assignment
names(globalPow)<-c("Date","Time","Global_active_power",
                    "Global_reactive_power","Voltage",
                    "Global_intensity","Sub_metering_1",
                    "Sub_metering_2","Sub_metering_3")

## Get a subset of data between 1 Feb 07 and 2 Feb 07
power2Days <- subset(globalPow, globalPow$Date=="1/2/2007" |
                             globalPow$Date =="2/2/2007")

## Remove missing values
power2Days <- power2Days[complete.cases(power2Days),]

## ----------------------------------- Plot 3 -------------------------
## Join Date and Time columns
datetime <- strptime(paste(power2Days$Date, power2Days$Time), 
                     "%d/%m/%Y %H:%M:%S", tz="EST")

## Add Column name
names(datetime) <- c("DateTime")

## Add Date Time column to power data subset
power2Days <- cbind(datetime, power2Days)

## Plot of datetime v Sub metering 1 data
plot(power2Days$datetime, power2Days$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering")

## Add Plot of datetime v Sub metering 2 data
lines(power2Days$datetime, power2Days$Sub_metering_2, type = "l", xlab = "", ylab = "Energy sub metering", col="red")

## Add Plot of datetime v Sub metering 3 data
lines(power2Days$datetime, power2Days$Sub_metering_3, type = "l",
     xlab = "", ylab = "Energy sub metering", col="blue")

## Add legend, big struggle to get the legend to completely showup
## when saved as 480x480 due to shrink in X - loosing aspect ratio
legend("topright", lty= 1, col = c("Black", "red", "blue"),
       inset=c(0.004, 0), legend = c( "Sub_metering_1", 
                                "Sub_metering_2", "Sub_metering_3"))

## Copy the Plot to a PNG file from output
dev.copy(png, file="plot3.png", width=480, height=480)

## Clear Plots
dev.off()

