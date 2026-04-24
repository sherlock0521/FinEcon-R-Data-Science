#################################
#
# 資料變換 ( Data Transformation )
#
#################################

## 打掃R studio

rm(list = ls())

## 設定環境 ( Set Envirmenyt )

# install.packages("nycflights13")

library(nycflights13)
library(tidyverse)
glimpse(flights)
View(flights)

## 變數介紹
# year           : 年份（全為 2013）
# month          : 月份（1–12）
# day            : 日期（1–31）
# time_hour      : 排定起飛的完整日期時間

# dep_time       : 實際起飛時間（格式 hhmm，如 517 = 05:17）
# sched_dep_time : 排定起飛時間
# dep_delay      : 起飛延誤（分鐘，負數 = 提早出發）

# arr_time       : 實際抵達時間
# sched_arr_time : 排定抵達時間
# arr_delay      : 抵達延誤（分鐘，負數 = 提早抵達）

# carrier        : 航空公司代碼（如 UA = 聯合、AA = 美國、DL = 達美）
# flight         : 航班號碼
# tailnum        : 飛機尾號（每架飛機的唯一識別碼）
# origin         : 出發機場（EWR / JFK / LGA）
# dest           : 目的地機場代碼

# air_time       : 飛行時間（分鐘）
# distance       : 飛行距離（英里）
# hour           : 排定起飛的小時數
# minute         : 排定起飛的分鐘數


# 先認識 |>
# 有時候我們要對資料做比較複雜的整理時 會需要他來幫助我們讓code容易讀
# 這個意思是把左邊的值傳入給右邊的函式
# 比如 x |> f(y) = f(x,y)
# 或是 x|> f(y) |> g(z) = g(f(x,y),z)


## 列 (row)

# filter()

# 延誤超過120分鐘的班機

flights |>
  filter(dep_delay > 120)

filter(flights, dep_delay > 120)

# 關於條件
# & ,  表示and
# | 表示或

# 在1月1日出發的航班

flights |>
  filter(month == 1 & day == 1)

# 選出在1月或2月出發的航班

flights |>
  filter(month == 1 | month == 2)

# 這裡有一個比較簡潔的方式

flights |>
  filter(month %in% c(1,2))

# %in% 可以保留變數等於右側值之一

# 執行filter 會進行過濾運算並創建一個新的資料框在印出來
# 並不會修改原本的flights資料集
# 如果要將篩選後的結果儲存

jan1 <- flights |>
  filter(month == 1 , day == 1)

# 常見錯誤 

flights |>
  filter(month = 1)

# arrange()

flights |>
  arrange(year, month, day, dep_time)

# 這會按照順序sort

flights |>
  arrange(desc(dep_delay))

# descending 下降的

# 請注意我們只是在排序資料而不是過濾資料

# distinct()

# 移除重複的列 如果有的話

flights |>
  distinct()

# 找出所有唯一的來源地與目的地

flights |>
  distinct(origin, dest)

# 想保留其他變數

flights |>
  distinct(origin, dest, .keep_all = TRUE)

# 所有航班都是1月1日 這不是巧合 
# distinct()會找出資料及中低一次出現的唯一列 然後丟棄其他列


## 欄 (column)

# mutate()

# 計算延誤航班在空中飛行時所彌補的時間
# 計算每小時英里

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

# 預設會在資料集的右側新加欄位 
# 我們可以用.before把新變數放到左側

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

# 也可以指定新變數要放哪裡

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

# 也可以使用.keep = "used" 留下有被用到的變數

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60, 
    speed = distance / air_time * 60,
    .keep = "used"
  )

# 請注意 我們並沒有將使用mutate計算出的變數儲存到原本的flights資料集
# 新變數只會被印出來 而不會儲存在資料集裡
# 如果未來需要這些新變數 我們就需要儲存這些新變數
# 我們可以把新變數儲存在原本的flights資料集或是儲存在新的資料集

# select()

# 按名稱選擇欄

flights |>
  select(year, month, day)

# 選擇年和日之間所有欄(包含年和日)

flights |>
  select(year:day)

# 選擇從年到日(包含兩端)以外的所有欄

flights |>
  select(!year:day)

# ! 代表not

# 選擇是字元的所有欄

flights |>
  select(where(is.character))

# rename()

flights |>
  rename(tail_num = tailnum)

# relocate()

flights |>
  relocate(time_hour, air_time)

# 預設會移動到最前面

flights |>
  relocate(time_hour, air_time, .after = day)

flights |>
  relocate(time_hour, air_time, .before = day)

# 可以使用.after或.before來控制要放哪裡


## 管線 (pipe)

# 要找出飛往Houston IAH機場的快速航班 

# 需要使用不只一個我們上面學的"動詞"
# 配上 |> 我們可以寫的比較容易閱讀

flights |>
  filter(dest == "IAH") |>
  mutate(speed = distance / air_time * 60) |>
  select(year:day, dep_time, carrier, flight, speed) |>
  arrange(desc(speed))

# 從過濾filter() 然後變動mutate() 在做選擇select() 最後排列arrange()

#如果沒有使用 |> 會長怎麼樣?

arrange(
  select(
    mutate(
      filter(flights, dest == "IAH"),
      speed = distance / air_time * 60
    ),
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)

# 看吧 很不容易看懂


## 分組

# group_by()

# 將資料切割成對分析有意義的組別

flights |>
  group_by(month)

# group_by()不會改變資料 但仔細看輸出結果 可以注意到資料的顯示是依據月份分組
# Groups:   month [12]

# summarise()

# 按月分組後 按月計算平均的出發延誤

flights |>
  group_by(month) |>
  summarise(
    avg_delay = mean(dep_delay)
  )

# 糟糕 怎麼全是NA
# 代表所觀測的航班中有些在延遲那欄中缺少資料
# 當我們在計算包刮那些遺漏值在內的平均數時 得到NA
# 告訴mean()忽略遺漏值

flights |>
  group_by(month) |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )

# 只需要用一次summarise() 就可以建立任意數量的摘要
# 這裡有一個好用的摘要 n()
# 這告訴我們每一組有幾個樣本

flights |>
  group_by(month) |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

# slice_

# 可以提取每組中的特定列

# 取出每一組的第一列

flights |>
  group_by(month) |>
  slice_head(n = 1)

# 取出每一組的最後一列

flights |>
  group_by(month) |>
  slice_tail(n = 1)

# 取出每一組dep_delay欄數值最小的一列

flights |>
  group_by(month) |>
  slice_min(dep_delay, n = 1)

# 取出每一組dep_delay欄數值最大的一列

flights |>
  group_by(month) |>
  slice_max(dep_delay, n = 1)

# 取出每一組的隨機一列

flights |>
  group_by(month) |>
  slice_sample(n = 1)

# .by

flights |>
  summarise(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )

flights |>
  summarise(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin, dest)
  )












