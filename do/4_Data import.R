#################################
#
# 資料匯入 ( Data import )
#
#################################


## 打掃R studio

rm(list = ls())

## 設定環境 ( Set Environment )

# install.packages("")

library(tidyverse)

# 讀一個資料--------------------

# 直接從網路讀取

students <- read_csv("https://pos.it/r4ds-students-csv")

# 或是下載後從本機讀取

students_01 <- read_csv("C:/Users/USER/Downloads/students.csv")

# 資料中有na

students_02 <- read_csv("C:/Users/USER/Downloads/students.csv", na = c("N/A", ""))

students_02

# 變數名稱有反引號 因為包含空格

students_02 |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

# 讀不只一個資料--------------------

sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
read_csv(sales_files, id = "file")

# 怎麼存檔--------------------

write_csv(students_02, "students.csv")

# write_csv(資料, 存哪裡)

# 手動建立資料--------------------

# by columns 

tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

# 這樣有點難看出各列之間的關係

# by rows

tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)

# 較容易閱讀 所打及所見


