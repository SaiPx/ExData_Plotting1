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


## ----------------------------------- Plot 2 -------------------------
## Join Date and Time columns
datetime <- strptime(paste(power2Days$Date, power2Days$Time), 
                           "%d/%m/%Y %H:%M:%S", tz="EST")

## Add Column name
names(datetime) <- c("DateTime")

## Add Date Time column to power data subset
power2Days <- cbind(datetime, power2Days)

## Make Line Plot of Time versus Global Active Power
plot(power2Days$datetime,power2Days$Global_active_power, 
     type="l", xlab="", ylab="Global Active Power (kilowatts)")

## Copy the Plot to a PNG file from output
dev.copy(png, file="plot2.png", width=480, height=480)
## clear the plot
dev.off()
