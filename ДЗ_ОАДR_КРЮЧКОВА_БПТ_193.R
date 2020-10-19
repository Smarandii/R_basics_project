# Крючкова БПТ - 193 19.10.2020
# Используемый датасет: "Canadian occupational prestige" ref: https://socialsciences.mcmaster.ca/jfox/Books/Applied-Regression-2E/datasets/Prestige.txt
# Датасет был приведён к формату comma-separated values file с помощью python скрипта для дальнейшего использования в R

library(dplyr) #Подключение модуля dplyr для использования функции filter

my_dataset <- read.csv(file.choose()) # Загружаем датасет (после выполнения команды нужно выбрать файл с расширением .txt)

head(my_dataset)

# На каких профессиях одновременно работает >50% женщин и зарплата выше 8000 у.е (вероятно канадских долларов)

income_plus8000 <- filter(my_dataset, income >= 8000) #Фильтруем датасет, чтобы получить все профессии с доходом выше 8000
half_women_income_plus8000 <- filter(income_plus8000, women >= 50) #Фильтруем датасет, чтобы получить все профессии с процентом женщин выше 50
head(half_women_income_plus8000) # получаем таблицу из одной записи: ECONOMISTS     14.44   8049 57.31     62.2   2311 prof

# С помощью функции mutate создаём новый датасет с 2-умя дополнительными столбцами : "man_census" и "woman_census", отвечающие за количество мужчин и женщин

mutated_dataset_1 <- my_dataset

mutate(mutated_dataset_1,
       man_census = round(census - census * (women/100), digits = 0),
       woman_census = round(census * (women/100), digits = 0))

# Использование case_when : Допустим работа считается престижной при 50% процентах и более, добавим новый столбец "is_prestige", который будет отображать этот факт значениями из множества {Yes, No}, где Yes - престижная работа, No - не престижная.

mutated_dataset_2 <- my_dataset

mutated_dataset_2 <- mutate(mutated_dataset_2, 
       is_prestige = case_when(
         mutated_dataset_2$prestige >= 50 ~ "Yes",
         TRUE ~ "No"
        )
       )

# Подсчёт описательных статистик
summary(my_dataset)


# t-test
# Нулевая Гипотеза: На престижных профессиях (>50%) в среднем платят больше денег чем на непрестижных
# Альтернативная Гипотеза: Средняя зарплата на престижных профессиях (>50%) меньше 10000 у.е 
# Проведём t-test, чтобы подтвердить \ опровергнуть
t.test(mutated_dataset_2$income~mutated_dataset_2$is_prestige, alt='two.sided', conf=0.95)
# Вывод: в результате t-test удалось подтвердить нулевую гипотезу  и альтернативную гипотезу


# Корреляционный анализ
# Нулевая Гипотеза: Чем престижнее профессия, тем меньше женщин на ней работают
# Альтернативная Гипотеза: Престиж не зависит от того, сколько женщин работает по данной профессии
# Проведём корреляционный анализ методом Пирсона
cor.test(my_dataset$women,
         my_dataset$prestige, method='pearson')
# Вывод: в результате корреляционного анализа нулевая гипотеза была отклонена, а альтернативная гипотеза была подтверждена







