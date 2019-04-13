
# EDA for MDS Retention Survey

**Research question: Does hours of sleep/study/lectures influence
retention level of MDS material?**

To answer this question, we collected 55 responses to [this two-part
survey](https://ubc.ca1.qualtrics.com/jfe/form/SV_eUS5juWqmoXA1Ux) from
MDS students and alumni.

Note the fist set of questions were on possible confounding factors
about each student/alumni. The second set of questions were a timed quiz
testing retention of MDS material.

**Our thought :**

> We designed the first set of questions to capture each respondent’s
> time spent on major activities of MDS program. As it is an accelerated
> program , there is very little gap between lectures and assignment
> submission . Hence , how much a respondant is able to study beyond the
> curriculum routine after the mandatory time one spents is one of the
> very vital information .  
> Over more than a century of research has established the fact that
> sleep benefits the retention of memory. Our question design tries to
> capture the same relationship between retention and hours of sleep .  
> The second set of questions are the key set for analysing retention,
> we created a timed quiz with question from MDS Block 1 to Block 5 .
> All questions were bjective , i.e. , TRUE/FALSE .

Let’s dive into the results.

#### Load the Data

We loaded the response and the quiz answers to do further analysis.

``` r
# helper functions
to_bool <- function(x) {ifelse(x == 'True', TRUE, FALSE)}

# set global variables
BIN_WIDTH = 2.0
PREPATH = ''

# read csv
raw_df <- read.csv(paste(PREPATH, 'data/mds-retention_2019-04-04.csv', sep="" ),
  stringsAsFactors = FALSE)

# load answer keys
answer_key <- read.csv(paste(PREPATH, 'data/answer_key.csv', sep="" ),
  stringsAsFactors = FALSE)
```

#### Clean the Data

The goal here is to format the data .

``` r
# remove second row as irrlevant
raw_df <- raw_df[-2,]

# get only the questions
raw_df <- raw_df %>% select(matches("Q[0-9]"))
questions <- unname(unlist(raw_df[1,]))

# removed unwanted row and enforce questions as columns
raw_df <- raw_df[-1,]
names(raw_df) <- questions

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

# save clean data
clean_df <- d_factors %>%
  cbind(retentions)

cat(sprintf("\n========>saving clean data to result\n\n"))
```

    ## 
    ## ========>saving clean data to result

``` r
write.csv(clean_df , file = paste(PREPATH, 'result/clean_data_long.csv', sep=""))
```

#### Wrangle the Data

The goal here is to create a clean dataset with shorter headers and
score correctness for each question of the retention section.

``` r
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

cat(sprintf("\n========> saving clean data with short header and scores\n\n"))
```

    ## 
    ## ========> saving clean data with short header and scores

``` r
write.csv(clean_data_short , file = paste(PREPATH, 'result/clean_data_short.csv', sep=""))

pander::pander(head(clean_data_short))
```

|    d1    | d2 | d3 |  d4  |  d5   |  r1   |  r2  |  r3   |  r4   |  r5   |
| :------: | :-: | :-: | :--: | :---: | :---: | :--: | :---: | :---: | :---: |
| 2018 -19 | 8  | 4  | 70.2 | 19.1  | FALSE | TRUE | FALSE | FALSE | FALSE |
| 2018 -19 | 8  | 4  | 50.9 | 29.76 | TRUE  | TRUE | TRUE  | TRUE  | TRUE  |
| 2018 -19 | 8  | 4  |  50  |  10   | FALSE | TRUE | FALSE | TRUE  | FALSE |
| 2018 -19 | 8  | 4  |  50  | 20.16 | FALSE | TRUE | FALSE | FALSE | TRUE  |
| 2018 -19 | 8  | 4  | 35.5 | 30.7  | TRUE  | TRUE | TRUE  | FALSE | FALSE |
| 2018 -19 | 8  | 4  | 40.1 | 20.03 | TRUE  | TRUE | TRUE  | TRUE  | FALSE |

Table continues below

|  r6   |  s1   |  s2   |  s3   |  s4   |  s5   |  s6   | average |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :-----: |
| TRUE  | FALSE | FALSE | TRUE  | FALSE | TRUE  | FALSE | 0.3333  |
| TRUE  | TRUE  | FALSE | FALSE | TRUE  | FALSE | FALSE | 0.3333  |
| TRUE  | FALSE | FALSE | TRUE  | TRUE  | TRUE  | FALSE |   0.5   |
| TRUE  | FALSE | FALSE | TRUE  | FALSE | FALSE | FALSE | 0.1667  |
| FALSE | TRUE  | FALSE | FALSE | FALSE | TRUE  | TRUE  |   0.5   |
| FALSE | TRUE  | FALSE | FALSE | TRUE  | TRUE  | TRUE  | 0.6667  |

#### Summary of Explanatory Variables

Below plots shows the average range of hours of sleep , hours of study
outside MDS program and time spent for lectures /labs .

``` r
continuous_d_factors_hist <- d_factors[,c(4,5)] %>%
    gather(key="questions", value="answers") %>%
    mutate(questions = str_wrap(questions, width = 80)) %>%
    ggplot(aes(x = answers)) +
    geom_histogram(binwidth=5) +
    facet_wrap(~questions,scales = "free", ncol=1) + 
    theme_minimal()

discrete_d_factor_plt <- d_factors[,c(-4,-5)] %>%
  gather(key="questions", value="answers") %>%
  ggplot(aes(x = answers)) +
  geom_bar( stat = 'count') +
  facet_wrap(~questions,scales = "free", ncol=1) +
  theme_minimal()

continuous_d_factors_hist
```

![](exploratory_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
discrete_d_factor_plt
```

![](exploratory_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

**What we observe**

> From the above plots we observe that most of the respondants sleep
> less than 7 hours per day .As they spent approximately more than 5
> hours a day for studying outside lectures and labs . This gives us a
> sense of these two variables might have interaction effect on our
> response variable that is retention .

#### Summary of Response (Retention Questions)

The first plot shows how many correct and incorrect answers given for
each question . The second plot shows the average score distribution .

``` r
retentions <- sapply( retentions, as.character )
```

``` r
# plot the retention questions

# preparing the dataframe to get the correctness of each answer
retentions <- as.data.frame(retentions) %>%
    gather(key="questions", value="answers") %>%
    left_join(answer_key, by='questions') %>%
    mutate(correct = (answers == answer_key))

score_distribution_plot <- clean_data_short %>%
  ggplot(aes(x = average)) +
  geom_density( fill ='lightblue') +
  labs(title='Distribution of average scores',
       x='Overall average out of 6 questions',
       y = 'Score distribution') +
  theme_minimal()

score_hist_plot <- clean_data_short %>%
  ggplot(aes(x = average)) +
  geom_histogram(bins=6) +
  labs(title='Distribution of average scores',
       x='Overall average out of 6 questions',
       y = 'Score distribution') +
  theme_minimal()

#retentions_plot
score_hist_plot
```

![](exploratory_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
retentions %>%
  mutate(questions = str_wrap(questions, width =  25),
         correct = ifelse(correct, "Correct Answer", "Incorrect Answer")) %>%
  mutate(correct = str_wrap(correct, width = 10 )) %>%
  ggplot(aes(x = correct, fill = correct)) +
  geom_bar(stat="count") +
  facet_wrap(~questions,scales = "free", ncol=3) +
  scale_fill_manual(name="correct", values=c("dodgerblue4","red4")) +
  theme_minimal()+
  labs(title='Correctness of answers for each question', x = 'Answers from participants' ) + 
  guides(fill=FALSE)
```

![](exploratory_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

**What we observe**

> From the above plots we observe that the incorrectness of responses is
> spreadout to all questions from every Block , not t just one Block ,
> perhaps depending on the subject matter .Which implies we cannot
> relate Block and retention . Also , if we see the average score
> distribution we can see it lies between 0.3 to 0.5 , giving us a sense
> that the retention is not very high .

> However , the data we collected is not very huge as we had 55
> respondants only , so this needs further ananlysis to establish impact
> of explanatory variables on retehtion. Also , due to time constarint
> the number of questions from each block has to be kept 1 or 2 , which
> for sure does not give detail sense of material but a very high level
> sense as the topics questioned are the very basics of MDS.

**Below is the summary table of responses**

``` r
data <- read.csv(paste(PREPATH, 'result/clean_data_short.csv', sep="" ),
  stringsAsFactors = FALSE)
# if you prefer the long question header otherwise comment it out
colnames(data)[2:12] <- questions

summary_df <- data.frame(unclass(summary(data)), check.names = FALSE, stringsAsFactors = FALSE)
pander::pander(summary(data))
```

|      X       | Which MDS cohort do you belong to? | On average during MDS, how many lectures do you attend per week? - Average Lectures (per week) |
| :----------: | :--------------------------------: | :--------------------------------------------------------------------------------------------: |
|  Min. : 1.0  |             Length:55              |                                          Min. :1.000                                           |
| 1st Qu.:14.5 |          Class :character          |                                         1st Qu.:8.000                                          |
| Median :28.0 |          Mode :character           |                                         Median :8.000                                          |
|  Mean :28.0  |                 NA                 |                                          Mean :7.582                                           |
| 3rd Qu.:41.5 |                 NA                 |                                         3rd Qu.:8.000                                          |
|  Max. :55.0  |                 NA                 |                                          Max. :8.000                                           |

Table continues
below

| On average during MDS, how many labs do you attend per week? - Average Labs (per week) | On average during MDS, how many hours of sleep did you get per week? - Average Hours (per week) |
| :------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------: |
|                                      Min. :1.000                                       |                                           Min. : 5.20                                           |
|                                     1st Qu.:4.000                                      |                                          1st Qu.:42.25                                          |
|                                     Median :4.000                                      |                                          Median :50.00                                          |
|                                      Mean :3.709                                       |                                           Mean :47.67                                           |
|                                     3rd Qu.:4.000                                      |                                          3rd Qu.:54.40                                          |
|                                      Max. :4.000                                       |                                           Max. :70.20                                           |

Table continues
below

| On average during MDS, how many hours of studying (outside lectures & labs) did you do per week? - Average Hours (per week) | Non-zero correlation implies non-zero co-variance. |
| :-------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------: |
|                                                         Min. : 0.00                                                         |                   Mode :logical                    |
|                                                        1st Qu.:16.21                                                        |                      FALSE:25                      |
|                                                        Median :24.08                                                        |                      TRUE :30                      |
|                                                         Mean :26.24                                                         |                         NA                         |
|                                                        3rd Qu.:31.90                                                        |                         NA                         |
|                                                         Max. :65.63                                                         |                         NA                         |

Table continues
below

| Recall= TP/(TP + FP) | For a decision tree algorithm the threshold value for splitting features at each node, is a hyper-parameter. |
| :------------------: | :----------------------------------------------------------------------------------------------------------: |
|    Mode :logical     |                                                Mode :logical                                                 |
|       FALSE:26       |                                                   FALSE:26                                                   |
|       TRUE :29       |                                                   TRUE :29                                                   |
|          NA          |                                                      NA                                                      |
|          NA          |                                                      NA                                                      |
|          NA          |                                                      NA                                                      |

Table continues
below

| L1 regularisation gives sparsity, but L2 does not. | For the function (4 log n +16n ) has asymptotic running time slower than linear time O(n). |
| :------------------------------------------------: | :----------------------------------------------------------------------------------------: |
|                   Mode :logical                    |                                       Mode :logical                                        |
|                      FALSE:11                      |                                          FALSE:40                                          |
|                      TRUE :44                      |                                          TRUE :15                                          |
|                         NA                         |                                             NA                                             |
|                         NA                         |                                             NA                                             |
|                         NA                         |                                             NA                                             |

Table continues
below

| Increasing MCMC sample size makes the point estimate closer to the true parameter value. |      s1       |      s2       |      s3       |
| :--------------------------------------------------------------------------------------: | :-----------: | :-----------: | :-----------: |
|                                      Mode :logical                                       | Mode :logical | Mode :logical | Mode :logical |
|                                         FALSE:20                                         |   FALSE:25    |   FALSE:29    |   FALSE:29    |
|                                         TRUE :35                                         |   TRUE :30    |   TRUE :26    |   TRUE :26    |
|                                            NA                                            |      NA       |      NA       |      NA       |
|                                            NA                                            |      NA       |      NA       |      NA       |
|                                            NA                                            |      NA       |      NA       |      NA       |

Table continues below

|      s4       |      s5       |      s6       |    average     |
| :-----------: | :-----------: | :-----------: | :------------: |
| Mode :logical | Mode :logical | Mode :logical |  Min. :0.1667  |
|   FALSE:11    |   FALSE:15    |   FALSE:35    | 1st Qu.:0.3333 |
|   TRUE :44    |   TRUE :40    |   TRUE :20    | Median :0.5000 |
|      NA       |      NA       |      NA       |  Mean :0.5636  |
|      NA       |      NA       |      NA       | 3rd Qu.:0.6667 |
|      NA       |      NA       |      NA       |  Max. :1.0000  |
