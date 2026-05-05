#
# 2026/05/06
# 
# 估計 beta_hat
#

rm(list = ls())

# 匯入資料--------------

library(readr)
data <- read_csv("C:/Wenson/中山學院/114-2/Econometrics_I_(Night)/Data_Code/rawdata/Table_3.1.csv")
View(data)

# 建立矩陣--------------

X <- as.matrix(data[, 2:6])  
Y <- as.matrix(data[, 1])  

# 估計 beta_hat----------

# 公式 beta_hat = (t(X)X)^-1t(X)Y

# 矩陣相乘 %*%
# 求矩陣的transpose 需要 t()
# 求反矩陣 需要 solve()

beta <- solve(t(X) %*% X) %*% t(X) %*% Y

View(Beta)

# 求 Residuals-----------

# 公式 Residuals = Y - Beta * X

error <- Y - X %*% beta

View(error)

# 計算 X * Residuals----

X_t_error <- t(X)%*%error

View(X_t_error)

# 求 error--------------

sum(error)



