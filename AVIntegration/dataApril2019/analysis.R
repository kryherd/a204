library(tidyverse)
setwd("~/misc/AVIntegration/dataApril2019")
avint <- list.files(pattern=".*2AFC.*\\.tsv")
avint_data <- do.call(rbind, lapply(avint, function(x) read.delim(x, stringsAsFactors = FALSE)))

goodness_files <- list.files(pattern=".*goodness.*\\.tsv")
good <- do.call(rbind, lapply(goodness_files, function(x) read.delim(x, stringsAsFactors = FALSE)))


av_summary <- avint_data %>% 
  filter(RT != 999) %>%
  group_by(StimType, StimCategory) %>%
  summarise(acc = mean(ACC),
            RT = mean(RT))

length(unique(avint_data$Subject)) # number of subjects

ggplot(av_summary, aes(StimType, acc)) + geom_bar(stat = "identity") + facet_grid(.~StimCategory) + theme_bw(15) +
  ggtitle("AV Int - May 2019 (n = 34)") + ylab("Accuracy")

ggplot(av_summary, aes(StimType, RT)) + geom_bar(stat = "identity") + facet_grid(.~StimCategory) + theme_bw(15)


good_summary <- good %>%
  filter(RT != 999) %>%
  group_by(StimType, StimCategory, Rating) %>%
  count() %>%
  mutate(pct = n/(9*34)) # change 34 to the number of subjects

good_summary %>%
  ungroup() %>%
  mutate(Rating = fct_relevel(Rating, "No B", "Weak", "Medium", "Strong")) %>%
  ggplot(., aes(StimType, pct, fill = Rating)) + geom_bar(stat = "identity") + facet_grid(.~StimCategory) +
  theme_bw(15) + scale_fill_brewer(palette = "Blues") + ggtitle("Goodness Ratings - May 2019 (n = 34)") + 
  ylab("Percent of Responses") 