# Setup -------------------------------------------------------------------

library(here)
source(here("code", "code_01_setup_01_libraries.R"))
source(here("code", "code_01_setup_02_api.R"))


# Read data ---------------------------------------------------------------

tweets <- read_rds(here("tweets_tidy_tf-idf.rds"))

# Frequency Analysis --------------------------------------------------

tweets_freq <- tweets   %>% arrange(-n)
tweets_freq <- tweets_freq %>% group_by(key)
tweets_freq <- tweets_freq %>% slice_max(order_by = n, n = 10, with_ties = FALSE)
tweets_freq <- tweets_freq %>% ungroup
tweets_freq <- tweets_freq %>% arrange(n %>% desc)
tweets_freq <- tweets_freq %>% mutate(words = reorder_within(words, n, key))
plot        <- tweets_freq %>% ggplot(aes(words, n, fill = key))
plot        <- plot        %+%   geom_col(alpha = 0.8, show.legend = FALSE)
plot        <- plot        %+%   facet_wrap(~ key, scales = "free", ncol = 3)
plot        <- plot        %+%   scale_x_reordered()
plot        <- plot        %+%   coord_flip()
plot        <- plot        %+%   theme(strip.text=element_text(size=11))
plot        <- plot        %+%   labs(x = NULL, y = "frequency",
                                      title = "Highest frequency words in Apruebo-Rechazo debate in Twitter",
                                      subtitle = "Individual stories focus on different characters and narrative elements")
plot %>% ggsave(here("figs","plot_freq.png"), ., height = 6, width = 10)

