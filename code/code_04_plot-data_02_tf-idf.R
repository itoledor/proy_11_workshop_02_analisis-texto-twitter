# Setup -------------------------------------------------------------------

library(here)
source(here("code", "code_01_setup_01_libraries.R"))
source(here("code", "code_01_setup_02_api.R"))


# Read data ---------------------------------------------------------------

tweets <- read_rds(here("tweets_tidy_tf-idf.rds"))

# Frequency Analysis --------------------------------------------------

tweets_tfidf <- tweets   %>% arrange(-tf_idf)
tweets_tfidf <- tweets_tfidf %>% group_by(key)
tweets_tfidf <- tweets_tfidf %>% slice_max(order_by = tf_idf, n = 10, with_ties = FALSE)
tweets_tfidf <- tweets_tfidf %>% head(10)
tweets_tfidf <- tweets_tfidf %>% ungroup
tweets_tfidf <- tweets_tfidf %>% arrange(tf_idf %>% desc)
tweets_tfidf <- tweets_tfidf %>% mutate(words = reorder_within(words, tf_idf, key))
plot         <- tweets_tfidf %>% ggplot(aes(words, tf_idf, fill = key))
plot         <- plot        %+%   geom_col(alpha = 0.8, show.legend = FALSE)
plot         <- plot        %+%   facet_wrap(~ key, scales = "free", ncol = 3)
plot         <- plot        %+%   scale_x_reordered()
plot         <- plot        %+%   coord_flip()
plot         <- plot        %+%   theme(strip.text=element_text(size=11))
plot         <- plot        %+%   labs(x = NULL, y = "tf-idf",
                                      title = "Highest tf-idf words in Apruebo-Rechazo debate in Twitter",
                                      subtitle = "Individual stories focus on different characters and narrative elements")
plot %>% ggsave(here("figs","plot_tfidf.png"), ., height = 6, width = 10)

