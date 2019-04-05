# %% [markdown]
# ## Data Visualization
# %%
# import library
library(tidyverse)
library(ggplot2)


# %%
# read csv
raw_df <- read.csv('data/mds-retention_2019-04-04.csv')

#print(head(raw_df))

# %%
# data cleaning
#remove second row as irrlevant
raw_df <- raw_df[-2,]

# get only the questions
raw_df <- raw_df %>% select(matches("Q[0-9]"))



questions <- unname(unlist(raw_df[1,]))

raw_df <- raw_df[-1,]
names(raw_df) <- questions

# %
#  get deciding factors
d_factors <- raw_df[,1:5]

d_factors[,c(4,5)] <- sapply( d_factors[,c(4,5)], as.numeric )

retentions <- raw_df[,6:ncol(raw_df)]

# %%
# make plot for deciding factors
discrete_d_factor_plt <- d_factors[,c(-4,-5)] %>%
  gather(key="questions", value="answers") %>%
  ggplot(aes(x = answers)) +
  geom_histogram(stat = 'count') +
  facet_wrap(~questions,scales = "free", ncol=1)

ggsave(filename="discrete_deciding_factors.png",
  plot=discrete_d_factor_plt,
  path='img')


continuois_d_factors_hist <- d_factors[,c(4,5)] %>%
    gather(key="questions", value="answers") %>%
    ggplot(aes(x = answers)) +
    geom_histogram() +
    facet_wrap(~questions,scales = "free", ncol=1)

ggsave(filename="continuous_deciding_factors_hist.png",
  plot=continuois_d_factors_hist,
  path='img')


continuois_d_factors_preq <- d_factors[,c(4,5)] %>%
    gather(key="questions", value="answers") %>%
    ggplot(aes(x = answers)) +
    geom_freqpoly() +
    facet_wrap(~questions,scales = "free", ncol=1)

ggsave(filename="continuous_deciding_factors_freqp.png",
  plot=continuois_d_factors_preq,
  path='img')
