# Setup -------------------------------------------------------------------

library(here)
source(here("code", "code_01_setup_01_libraries.R"))
source(here("code", "code_01_setup_02_api.R"))

# Read data ------------------------------------------------------------

apruebo <- read_rds(here("data", str_c(Sys.Date(),"_apruebo.rds")))
rechazo <- read_rds(here("data", str_c(Sys.Date(),"_rechazo.rds")))

# Custon stop words ---------------------------------------------------------------

custom_stop_words <- tibble(words = c("de","el", "del", "la", "y", "o", "no", "los", "las", "a", "por", "en", "que", "t.co", "me",
                                      "yo", "es", "con", "si", "al", "un", "para", "lo", "sin", "eso", "se", "una", "su", "est","va",
                                      "como", "hasta", "ha", "pero", "son", "esto"))

# Tidy data ---------------------------------------------------------------

data <- apruebo %>% bind_rows(rechazo)
data <- data %>% distinct()
data <- data %>% select(status_id, text, key)
data <- data %>% filter(text %>% str_detect("Escazú") %>% not())
data <- data %>% filter(text %>% str_detect("Escazu") %>% not())
data <- data %>% mutate(text = text %>% plain_tweets())
data <- data %>% group_by(status_id)
data <- data %>% mutate(key = key %>% paste(collapse = "_"))
data <- data %>% distinct()
data <- data %>% mutate(key = key %>% equals("rechazo_rechazo") %>% if_else("rechazo", key))
data <- data %>% unnest_tokens(output = words, input = text, token = "words")
data <- data %>% anti_join(custom_stop_words, by = c("words"))

# Summarise data ----------------------------------------------------------

data <- data %>% group_by(status_id, key)
data <- data %>% count(words)
data <- data %>% bind_tf_idf(term = words, document = status_id, n = n)
data <- data %>% group_by(key, words)
data <- data %>% summarise_if(is.numeric, mean)

# Save data ---------------------------------------------------------------

data %>% write_rds(here("tweets_tidy_tf-idf.rds"))
