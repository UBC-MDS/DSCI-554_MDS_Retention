# %% [markdown]
# # Data Exploratory and Visualization
# Authors: Mike Yuan and Shayne Andrew

# [markdown]
# ## Load Library and helper functions

# %%
# import library
library(tidyverse)
library(ggplot2)
library(stringr)


# %%
# helper functions

to_bool <- function(x) {ifelse(x == 'True', TRUE, FALSE)}


# [markdown]
# ## Define global varible for binwidth when plotting histogram

# %%
# set global variables

BIN_WIDTH = 2.0

# %%
# read csv
raw_df <- read.csv('data/mds-retention_2019-04-04.csv',
  stringsAsFactors = FALSE)

  # load answer keys

answer_key <- read.csv('data/answer_key.csv',
  stringsAsFactors = FALSE)

# %%
# data cleaning
# remove second row as irrlevant
raw_df <- raw_df[-2,]

# get only the questions
raw_df <- raw_df %>% select(matches("Q[0-9]"))
questions <- unname(unlist(raw_df[1,]))

# removed unwanted row and enforce questions as columns
raw_df <- raw_df[-1,]
names(raw_df) <- questions

# %
#  get deciding factors
d_factors <- raw_df[,1:5]

# convert character to numeric for hours
d_factors[,2:5] <- sapply( d_factors[,2:5], as.numeric )

retentions <- raw_df[,6:ncol(raw_df)]
# convert character to bool for retention question
retentions <- retentions %>%
  mutate_all(to_bool)

# enforce the questions in answer_key and dataframe matche
answer_key$questions <- colnames(retentions)


# %%
# save clean data
clean_df <- d_factors %>%
  cbind(retentions)


cat(sprintf("\n========>saving clean data to result\n\n"))
write.csv(clean_df , file = 'result/clean_data_long.csv')

# showing the head of the clean data for Rmd
head(clean_df)

# [markdown]
# ### Preparing clean data for data analysis
# The goal here is to create a clean dataset with shorter header and score for each question
# Also, include the average score

# %%
# prepare for clean data with short handing for data anaysis
clean_data_short <- clean_df

# d for deciding factors
# r for retention questions
# s for score for each retention question
colnames(clean_data_short) <- c('d1', 'd2', 'd3', 'd4', 'd5',
                                'r1', 'r2', 'r3', 'r4', 'r5', 'r6')
clean_data_short <- clean_data_short %>%
  mutate(s1 = (r1 == TRUE),
         s2 = (r2 == FALSE),
         s3 = (r3 == FALSE),
         s4 = (r4 == TRUE),
         s5 = (r5 == FALSE),
         s6 = (r6 == FALSE)) %>%
  mutate(average = (s1 + s2 + s3 + s4 + s5 + s6)/6)

cat(sprintf("\n========>saving clean data with short header and scores\n\n"))
write.csv(clean_data_short , file = 'result/clean_data_short.csv')


# %%
# make plot for deciding factors
cat(sprintf("\n========> saving deciding factor plots\n\n"))
discrete_d_factor_plt <- d_factors[,c(-4,-5)] %>%
  gather(key="questions", value="answers") %>%
  ggplot(aes(x = answers)) +
  geom_bar( stat = 'count') +
  facet_wrap(~questions,scales = "free", ncol=1)

ggsave(filename="discrete_deciding_factors.png",
  plot=discrete_d_factor_plt,
  path='img')


continuous_d_factors_hist <- d_factors[,c(4,5)] %>%
    gather(key="questions", value="answers") %>%
    ggplot(aes(x = answers)) +
    geom_histogram(binwidth=BIN_WIDTH) +
    facet_wrap(~questions,scales = "free", ncol=1)

ggsave(filename="continuous_deciding_factors_hist.png",
  plot=continuous_d_factors_hist,
  path='img')


continuous_d_factors_preq <- d_factors[,c(4,5)] %>%
    gather(key="questions", value="answers") %>%
    ggplot(aes(x = answers)) +
    geom_freqpoly(binwidth=BIN_WIDTH) +
    facet_wrap(~questions,scales = "free", ncol=1)

ggsave(filename="continuous_deciding_factors_freqp.png",
  plot=continuous_d_factors_preq,
  path='img')

# [markdown]
# Show deciding factor plots

# %%
# show continous
continuous_d_factors_preq
continuous_d_factors_hist
discrete_d_factor_plt

# %%
# plot the retention questions


retentions <- sapply( retentions, as.character )

# preparing the dataframe to get the correctness of each answer
retentions <- as.data.frame(retentions) %>%
    gather(key="questions", value="answers") %>%
    left_join(answer_key, by='questions') %>%
    mutate(correct = (answers == answer_key))


retentions_plot <- retentions %>%
  mutate(questions = str_wrap(questions, width =  25)) %>%
  ggplot(aes(x = answers, fill = correct)) +
  geom_bar(stat="count") +
  facet_wrap(~questions,scales = "free", ncol=3)

cat(sprintf("\n========> saving retention question plots\n\n"))
ggsave(filename="retentions.png",
  plot=retentions_plot,
  path='img')

# [markdown]
# show renteion plot
# %%
# show retention plot
retentions_plot

# [markdown]
# show distribution of the average scores
# %%
score_distribution_plot <- clean_data_short %>%
  ggplot(aes(x = average)) +
  geom_density( fill ='lightblue') +
  labs(title='Distribution of average scores',
       x='Overall average out of 6 questions',
       y = 'Score distribution')


cat(sprintf("\n========> saving score average distribution plot\n\n"))
ggsave(filename="score_average.png",
  plot=score_distribution_plot,
  path='img')

# save historgram
score_hist_plot <- clean_data_short %>%
  ggplot(aes(x = average)) +
  geom_histogram(bins=6) +
  labs(title='Distribution of average scores',
       x='Overall average out of 6 questions',
       y = 'Score distribution')


cat(sprintf("\n========> saving score average histogram plot\n\n"))
ggsave(filename="score_average_hist.png",
  plot=score_hist_plot,
  path='img')
