rm(list=ls())

setwd("C:/Users/singh/Desktop")
#import the data
data<-read.csv("Insta_history.csv")
data1=data

#all unique cryptos that I have invested in
cryptos = unique(data1['Currency'])[[1]]
crypto_count = length(cryptos)

#number of transactions
data_rows = nrow(data1)

#extracting the date of purchase
#a = data1['Created.At'][[1]][1]
#strsplit(a, " ")[[1]][1]

crp_amt_buy <- c()
crp_units_buy <- c()
crp_amt_sell <- c()
crp_units_sell <- c()

for (i in 1 : crypto_count) {
  current_crypto = cryptos[i]
  curr_crp_amt_buy = 0
  curr_crp_units_buy = 0
  curr_crp_amt_sell = 0
  curr_crp_units_sell = 0
  
  for (j in 1:data_rows) {
    if ((data1[['Currency']][j]==current_crypto) && (data1[['Side']][j]=="buy")) {
      curr_crp_amt_buy = curr_crp_amt_buy + as.numeric(data1[['Total.Amount']][j])
      curr_crp_units_buy = curr_crp_units_buy + as.double(data1[['Total.Quantity']][j])
    }
    
    if ((data1[['Currency']][j]==current_crypto) && (data1[['Side']][j]=="sell")) {
      curr_crp_amt_sell = curr_crp_amt_sell + as.numeric(data1[['Total.Amount']][j])
      curr_crp_units_sell = curr_crp_units_sell + as.double(data1[['Total.Quantity']][j])
    }
  }
  
  crp_amt_buy = append(crp_amt_buy, curr_crp_amt_buy)
  crp_units_buy = append(crp_units_buy, curr_crp_units_buy)
  crp_amt_sell = append(crp_amt_sell, curr_crp_amt_sell)
  crp_units_sell = append(crp_units_sell, curr_crp_units_sell)
}

new_data <- data.frame(cryptos, crp_amt_buy, crp_units_buy, crp_amt_sell, crp_units_sell)
colnames(new_data) <- c("Crypto", "Amount Bought", "Units Bought", "Amount Sold", "Units Sold")

buy_price <- c()
sell_price <- c()

for (i in 1:crypto_count) {
  buy_price[i] = new_data[['Amount Bought']][i]/new_data[['Units Bought']][i]
  sell_price[i] = new_data[['Amount Sold']][i]/new_data[['Units Sold']][i]
}

new_data = cbind(new_data,buy_price,sell_price)
write.csv(new_data, file="crypto_test_outcome.csv")

