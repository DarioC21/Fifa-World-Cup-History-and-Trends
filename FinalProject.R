# ECON 4970 Final Project
# FIFA World Cup History and Trends

library(tidyverse)
library(scales)
library(broom)

# 1. Load data

wcmatches <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2022/2022-11-29/wcmatches.csv",
  show_col_types = FALSE
)

worldcups <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2022/2022-11-29/worldcups.csv",
  show_col_types = FALSE
)


# 2. Clean data

continent_lookup <- tribble(
  ~team, ~continent,
  "Uruguay", "South America",
  "Argentina", "South America",
  "Brazil", "South America",
  "Chile", "South America",
  "Paraguay", "South America",
  "Peru", "South America",
  "Bolivia", "South America",
  "Colombia", "South America",
  "Ecuador", "South America",
  "USA", "North America",
  "United States", "North America",
  "Mexico", "North America",
  "Costa Rica", "North America",
  "Canada", "North America",
  "Honduras", "North America",
  "Jamaica", "North America",
  "Trinidad and Tobago", "North America",
  "Cuba", "North America",
  "Haiti", "North America",
  "El Salvador", "North America",
  "Panama", "North America",
  "England", "Europe",
  "Italy", "Europe",
  "France", "Europe",
  "Spain", "Europe",
  "Portugal", "Europe",
  "Germany", "Europe",
  "West Germany", "Europe",
  "East Germany", "Europe",
  "Netherlands", "Europe",
  "Belgium", "Europe",
  "Sweden", "Europe",
  "Switzerland", "Europe",
  "Austria", "Europe",
  "Hungary", "Europe",
  "Poland", "Europe",
  "Soviet Union", "Europe",
  "Russia", "Europe",
  "Croatia", "Europe",
  "Czech Republic", "Europe",
  "Czechoslovakia", "Europe",
  "Serbia", "Europe",
  "Serbia and Montenegro", "Europe",
  "Yugoslavia", "Europe",
  "Romania", "Europe",
  "Bulgaria", "Europe",
  "Turkey", "Europe",
  "Ukraine", "Europe",
  "Denmark", "Europe",
  "Norway", "Europe",
  "Scotland", "Europe",
  "Wales", "Europe",
  "Republic of Ireland", "Europe",
  "Northern Ireland", "Europe",
  "Greece", "Europe",
  "Slovenia", "Europe",
  "Slovakia", "Europe",
  "Bosnia and Herzegovina", "Europe",
  "Iceland", "Europe",
  "Cameroon", "Africa",
  "Nigeria", "Africa",
  "Senegal", "Africa",
  "Ghana", "Africa",
  "Algeria", "Africa",
  "Morocco", "Africa",
  "Tunisia", "Africa",
  "South Africa", "Africa",
  "Egypt", "Africa",
  "Angola", "Africa",
  "Togo", "Africa",
  "Cote d'Ivoire", "Africa",
  "Japan", "Asia",
  "South Korea", "Asia",
  "Saudi Arabia", "Asia",
  "Iran", "Asia",
  "Iraq", "Asia",
  "China", "Asia",
  "North Korea", "Asia",
  "Qatar", "Asia",
  "United Arab Emirates", "Asia",
  "Kuwait", "Asia",
  "Israel", "Asia",
  "Australia", "Oceania",
  "New Zealand", "Oceania"
)

matches_clean <- wcmatches %>%
  mutate(
    total_goals = home_score + away_score,
    draw = if_else(outcome == "draw", 1, 0)
  )

get_host_finish <- function(host, winner, second, third, fourth) {
  hosts <- str_split(host, ",")[[1]] %>% str_trim()
  
  if (winner %in% hosts) {
    return("Winner")
  } else if (second %in% hosts) {
    return("Runner-up")
  } else if (third %in% hosts) {
    return("Third")
  } else if (fourth %in% hosts) {
    return("Fourth")
  } else {
    return("Outside top 4")
  }
}

same_continent_as_host <- function(host, team_name, lookup_table) {
  hosts <- str_split(host, ",")[[1]] %>% str_trim()
  
  host_continents <- lookup_table %>%
    filter(team %in% hosts) %>%
    pull(continent) %>%
    unique()
  
  team_continent <- lookup_table %>%
    filter(team == team_name) %>%
    pull(continent)
  
  if (length(team_continent) == 0 || length(host_continents) == 0) {
    return(NA)
  }
  
  return(team_continent %in% host_continents)
}

worldcups_clean <- worldcups %>%
  mutate(
    attendance_per_game = attendance / games,
    goals_per_game = goals_scored / games,
    host_finish = pmap_chr(
      list(host, winner, second, third, fourth),
      get_host_finish
    ),
    host_top4 = if_else(host_finish == "Outside top 4", 0, 1),
    host_won = if_else(host_finish == "Winner", 1, 0),
    winner_same_continent = map2_lgl(
      host, winner,
      ~ same_continent_as_host(.x, .y, continent_lookup)
    )
  )

# 3. Tables

table_host_performance <- worldcups_clean %>%
  count(host_finish) %>%
  mutate(percent = round(100 * n / sum(n), 1))

print(table_host_performance)

table_top_winners <- worldcups_clean %>%
  count(winner, sort = TRUE) %>%
  rename(country = winner, titles = n)

print(table_top_winners)

table_stage_summary <- matches_clean %>%
  group_by(stage) %>%
  summarise(
    matches = n(),
    avg_goals = round(mean(total_goals), 2),
    draw_rate = round(mean(draw) * 100, 1),
    .groups = "drop"
  ) %>%
  arrange(desc(matches))

print(table_stage_summary)

write_csv(table_host_performance, "table_host_performance.csv")
write_csv(table_top_winners, "table_top_winners.csv")
write_csv(table_stage_summary, "table_stage_summary.csv")

# 4. Graphs

graph1 <- ggplot(worldcups_clean, aes(x = year, y = attendance_per_game)) +
  geom_line(linewidth = 1.2, color = "#1f4e79") +
  geom_point(size = 3, color = "#1f4e79") +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed", color = "#b22222") +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Average Attendance per Match Over Time",
    x = "Year",
    y = "Attendance per match"
  ) +
  theme_minimal(base_size = 14)

ggsave("graph1_attendance_trend.png", graph1, width = 10, height = 6, dpi = 300)

graph2 <- ggplot(worldcups_clean, aes(x = year, y = goals_per_game)) +
  geom_line(linewidth = 1.2, color = "#2e8b57") +
  geom_point(size = 3, color = "#2e8b57") +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed", color = "#b22222") +
  labs(
    title = "Goals per Match Over Time",
    x = "Year",
    y = "Goals per match"
  ) +
  theme_minimal(base_size = 14)

ggsave("graph2_goals_trend.png", graph2, width = 10, height = 6, dpi = 300)

graph3_data <- worldcups_clean %>%
  count(host_finish) %>%
  mutate(
    host_finish = factor(
      host_finish,
      levels = c("Winner", "Runner-up", "Third", "Fourth", "Outside top 4")
    )
  )

graph3 <- ggplot(graph3_data, aes(x = host_finish, y = n, fill = host_finish)) +
  geom_col(width = 0.7, show.legend = FALSE) +
  geom_text(aes(label = n), vjust = -0.3, size = 5) +
  labs(
    title = "Host Country Performance",
    x = "Finish",
    y = "Number of tournaments"
  ) +
  theme_minimal(base_size = 14)

ggsave("graph3_host_performance.png", graph3, width = 10, height = 6, dpi = 300)

graph4 <- table_top_winners %>%
  slice_head(n = 10) %>%
  ggplot(aes(x = reorder(country, titles), y = titles)) +
  geom_col(fill = "#6a5acd") +
  geom_text(aes(label = titles), hjust = -0.2, size = 5) +
  coord_flip() +
  labs(
    title = "Top 10 World Cup Winners",
    x = "",
    y = "Number of titles"
  ) +
  theme_minimal(base_size = 14)

ggsave("graph4_top_winners.png", graph4, width = 10, height = 6, dpi = 300)

graph5_data <- worldcups_clean %>%
  mutate(
    winner_same_continent = if_else(winner_same_continent, "Yes", "No")
  ) %>%
  count(winner_same_continent)

graph5 <- ggplot(graph5_data, aes(x = winner_same_continent, y = n, fill = winner_same_continent)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = n), vjust = -0.3, size = 5) +
  labs(
    title = "Winner From Same Continent as Host",
    x = "Same continent as host",
    y = "Number of tournaments"
  ) +
  theme_minimal(base_size = 14)

ggsave("graph5_same_continent.png", graph5, width = 10, height = 6, dpi = 300)

# 5. Regressions

model_attendance <- lm(attendance_per_game ~ year, data = worldcups_clean)
model_goals <- lm(goals_per_game ~ year, data = worldcups_clean)

attendance_results <- tidy(model_attendance)
goals_results <- tidy(model_goals)

print(attendance_results)
print(goals_results)

write_csv(attendance_results, "attendance_regression_results.csv")
write_csv(goals_results, "goals_regression_results.csv")
