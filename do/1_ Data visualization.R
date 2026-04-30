##########################
#
# 資料視覺化  ( Data visualization )
#
##########################

## 打掃R studio

rm(list = ls())

## 設定環境 ( Set Envirmenyt )

install.packages("tidyverse")


# 只需要安裝一次套件 但每次想試用時必須載入它
# tidy adj. 整齊的
# tidyverse 整齊宇宙 vs. messverse 混亂宇宙

install.packages("palmerpenguins")

install.packages("ggthemes")


# palmerpenguins:penguins資料集 
#                包含Palmer Archipelago三個島嶼上企鵝的身體測量資料

# ggthemes:提供對色盲友善的調色盤

# 到隔壁視窗打出penguins 
# 你應該會看到R印出預覽的內容
# 或是

library(tidyverse)
library(palmerpenguins)
library(ggthemes)
glimpse(penguins)
View(penguins)

# 這裡有兩個方法偷看資料長甚麼樣子

## 我們的問題
## 考慮到企鵝種類(species) 鰭肢(fippers)長的企鵝比鰭肢短的企鵝種還是輕

## 我們的目標

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)+
  geom_point(aes(colour = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "企鵝體重與鰭肢",
    subtitle = "Dimension for Adelie, Chinstrap and Gentoo penguin",
    x = "鰭肢長度(mm)", y = "體重(g)",
    color = "Species", shape = "Species"
  )+
  scale_color_colorblind()


## 怎麼做?

ggplot(data = penguins)

# 拿一個空白的畫紙來

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)

# 告訴R我想要資料中哪一個變數畫在X軸或Y軸 
# 這個過程叫做mapping
# aesthetics 美學元素


ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)+
  geom_point()

# 是一個散布圖 但跟我們的目標不一樣
# geometrical object 幾何物件
# 等等 出現警告訊息 !

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
)+
  geom_point()

# 在畫紙上就先區分好不同品種不同顏色

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
)+
  geom_point()+
  geom_smooth(method = "lm")

# 加上趨勢線
# 但怎麼不同品種都有趨勢線

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)+
  geom_point(mapping = aes(color = species))+
  geom_smooth(method = "lm")

# 在你想要的地方區分顏色

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)+
  geom_point(mapping =aes(color = species, shape = species))+
  geom_smooth(method = "lm")

# 顏色不夠 還要不同形狀

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)+
  geom_point(aes(colour = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "企鵝體重與鰭肢",
    subtitle = "Dimension for Adelie, Chinstrap and Gentoo penguin",
    x = "鰭肢長度(mm)", y = "體重(g)",
    color = "Species", shape = "Species"
  )+
  scale_color_colorblind()

# 大功告成


# 看看其他的圖

# 類別變數怎麼畫圖

ggplot(penguins, aes(x = species))+
  geom_bar()

# 如果對順序有偏好

ggplot(penguins, aes(x = fct_infreq(species)))+
  geom_bar()

# 數值變數怎麼畫圖

ggplot(penguins, aes(x = body_mass_g))+
  geom_histogram()

ggplot(penguins, aes(x = body_mass_g))+
  geom_histogram(binwidth =  20)

ggplot(penguins, aes(x = body_mass_g))+
  geom_histogram(binwidth =  200)

ggplot(penguins, aes(x = body_mass_g))+
  geom_histogram(binwidth =  2000)

# 或是

ggplot(penguins, aes(x = body_mass_g))+
  geom_density()


# 同時看一個類別變數一個數值變數

ggplot(penguins, aes(x = species, y = body_mass_g))+
  geom_boxplot()

# 或是

ggplot(penguins, aes(x = body_mass_g, color = species))+
  geom_density()


# 兩個類別變數

ggplot(penguins, aes(x = island))+
  geom_bar()

ggplot(penguins, aes(x = island, fill = species))+
  geom_bar()

ggplot(penguins, aes(x = island, fill = species))+
  geom_bar(position = "fill")
