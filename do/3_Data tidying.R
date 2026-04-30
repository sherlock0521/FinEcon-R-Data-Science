#################################
#
# 資料整理 ( Data tidying )
#
#################################


# 甚麼是"整齊的資料"?

# 使資料整齊的三條規則是 : 變數為欄 , 觀測值為列 , 值為單元格
# see : https://r4ds.hadley.nz/data-tidy.html


## 打掃R studio

rm(list = ls())

## 設定環境 ( Set Environment )

# install.packages("")

library(tidyverse)


# 資料加長 --------------------------------

billboard

# 記錄了2000年Billboard(告示牌)的歌曲排名

# 在這個資料集中 每一個觀測值都是一首歌曲
# 前三欄(artist  track date.entered)是描述歌曲的變數
# 然而 我們有76欄(wk1 ~ wk76)來描述歌曲在每周的排名

billboard |>
  pivot_longer(
    cols = starts_with("wk"),   # 把所有 wk 開頭的欄位「收起來」
    names_to = "week",          # 欄位名稱（wk1, wk2...）變成新欄位叫 "week"
    values_to = "rank"          # 欄位裡的值（排名數字）變成新欄位叫 "rank"
  )

# 原本一首歌佔一列，轉換後一首歌的每一週各佔一列。
# 把橫向展開的 76 個「週排名欄」直向疊起來，變成 week 和 rank 兩欄，讓資料更整齊、更適合分析

# 如果一首歌進入前100名的時間少於76周
# 以2 Pac  Baby Don't Cry 為例 這首歌在前100名只停留了七周
# 我們想排除一首歌掉出100名

billboard |>
  pivot_longer(
    cols = starts_with("wk"),   
    names_to = "week",          
    values_to = "rank",
    values_drop_na = TRUE
  )

# 大功告成 現在資料是整齊的了
# 但week不是數字 

billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )

# parse_number 可以幫我們從字串中擷取第一個數字而忽略所有文字

# 現在我們可以好好地看看歌曲排名隨著時間變化

billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()

# 我們可以發現 很少有歌曲能在前100名停留20周以上

# How pivoting work ?

df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)

# 三個病人 每個人量兩次血壓

# 但我們希望資料包含三個變數 
# id (有了) , measurement(欄名) , value(單元格值)
# 我們需要對df"加長"

df |> 
  pivot_longer(
    cols = bp1:bp2,            # 「要被拆解」的欄是 bp1 和 bp2
    names_to = "measurement",  # 欄的「名稱」(bp1, bp2) 存進新欄叫 measurement
    values_to = "value"        # 欄的「數值」(100, 120...) 存進新欄叫 value
  )

# 資料增寬 --------------------------------

cms_patient_experience

# 有關患者就醫體驗調查資料

# 資料的「問題」在哪裡？
# 每一個機構的每一個調查指標佔一列

cms_patient_experience |> 
  distinct(measure_cd, measure_title)

# 列出所有不同的調查指標，共有幾種 measure_cd
# 同一個機構被重複了很多列，每列只差在 measure_cd 不同

cms_patient_experience |>
  pivot_wider(
    names_from = measure_cd,   # 用 measure_cd 欄的「值」(CAHPS_GRP_1...) 當新欄位的名稱
    values_from = prf_rate     # 用 prf_rate 欄的「值」(63, 55...) 填入對應欄位的數字
  )

# 原本一個機構佔多列，轉換後每個機構只佔一列
# 把直向堆疊的 measure_cd 「攤平」成多個欄位，讓每個機構的所有指標集中在同一列
# 但每個組織還是不只一列
# 我們需要告訴 pivot_wider 哪幾欄可以唯一識別每一列

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),  # 用 org_pac_id 和 org_nm 兩欄合起來唯一識別每一列
    names_from = measure_cd,
    values_from = prf_rate
  )

# How pivoting work ?

# 回到量血壓的例子

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

# 我們從value欄中獲得值 measurement欄中獲得名稱

df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )










