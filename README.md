FIFA World Cup History and Trends
Project Motivation

The FIFA World Cup is one of the biggest sporting events in the world, and it has changed a lot over time. This project studies how the tournament has evolved in terms of popularity, scoring, and team success. I was especially interested in whether host countries perform better and whether location plays a role in determining which teams succeed.

Research Questions

This project focuses on five main research questions:

Has World Cup attendance per match increased over time?
Has scoring, measured by goals per match, changed over time?
Do host countries perform better when they host the World Cup?
Which countries have been the most successful in World Cup history?
Is there evidence of regional advantage, meaning that winners often come from the same continent as the host country?
Data Source

The data for this project comes from the TidyTuesday FIFA World Cup dataset from November 29, 2022. https://github.com/rfordatascience/tidytuesday/tree/main/data/2022/2022-11-29
Two datasets were used:
worldcups.csv for tournament-level information such as host, winner, attendance, number of games, and goals scored
wcmatches.csv for match-level information such as scores, stage, and match outcomes

Files in this Repository
FinalProject.R : main R script used for the full analysis
graph1_attendance_trend.png : attendance per match over time
graph2_goals_trend.png : goals per match over time
graph3_host_performance.png : host country performance
graph4_top_winners.png : top 10 World Cup winners
graph5_same_continent.png : winners from same continent as host
table_host_performance.csv : summary of how host countries performed
table_top_winners.csv : number of World Cup titles by country
table_stage_summary.csv : match stage summary
attendance_regression_results.csv : regression results for attendance trend
goals_regression_results.csv : regression results for goals trend
Methods

I used R to clean, organize, and analyze the data. First, I created tournament-level variables such as attendance per game and goals per game. Then I created variables to measure host-country success and whether the winner came from the same continent as the host. I also created summary tables and visualizations to compare tournament trends over time.

To measure trends over time, I estimated simple linear regression models for:

attendance per match as a function of year
goals per match as a function of year
Results
1. Attendance per Match Over Time

The first graph shows that average attendance per match generally increased over time, even though there were some fluctuations across tournaments. This suggests that the World Cup became more popular and attracted larger global audiences over time.




2. Goals per Match Over Time

The second graph shows that goals per match generally declined over time. Earlier tournaments were often higher scoring, while more recent World Cups were lower scoring on average. This may suggest that the tournament became more competitive, more balanced, or more defensive over time.




3. Host Country Performance

One of the most interesting findings is that host countries often performed strongly. Host nations finished in the top four in 12 out of 21 tournaments, and 5 host countries won the World Cup. This suggests that home advantage may matter in international tournaments.




4. Top 10 World Cup Winners

The graph of the top 10 World Cup winners shows that a small group of countries has historically dominated the competition. Brazil had the most titles, followed by Italy and West Germany. This suggests that World Cup success has been concentrated among a few strong football nations.




5. Regional Advantage

The final graph shows that in 14 out of 21 tournaments, the winner came from the same continent as the host country. Only 7 winners came from a different continent. This suggests that location may matter, possibly because of travel distance, climate, fan support, or familiarity with the region.




Conclusion

Overall, this project shows that the FIFA World Cup has changed in important ways over time. Attendance per match generally increased, showing growth in popularity, while goals per match generally declined, suggesting changes in the style of competition. The analysis also found evidence of host-country advantage and regional advantage. In addition, World Cup success has historically been concentrated among a small number of countries.

These findings show that the World Cup is not only a global sporting event, but also a tournament where geography and hosting conditions may influence success.
