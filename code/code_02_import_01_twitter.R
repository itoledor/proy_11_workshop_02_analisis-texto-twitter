# Setup -------------------------------------------------------------------

library(here)
source(here("code", "code_01_setup_01_libraries.R"))
source(here("code", "code_01_setup_02_api.R"))

# Create token ------------------------------------------------------------

geo   <- read_rds(here("data","geocode_chile.rds"))
api   <- read_rds(here("data","api.rds"))
token <- create_token(api$app_name        , 
                      api$consumer_key    , 
                      api$consumer_secret , 
                      api$access_token    , 
                      api$access_secret   )

# Import data -------------------------------------------------------------

plebiscito <- search_tweets(q = "plebiscito", token = token)

apruebo <- search_tweets(q = "apruebo",
                         n = 100000,
                         token = token,
                         geocode = geo, 
                         retryonratelimit = TRUE)
apruebo <- apruebo %>% mutate(key = "apruebo")

rechazo <- search_tweets(q = "rechazo",
                         n = 100000,
                         token = token,
                         geocode = geo, 
                         retryonratelimit = TRUE)
rechazo <- rechazo %>% mutate(key = "rechazo")

# Save data ---------------------------------------------------------------

apruebo %>% write_rds(here("data", str_c(Sys.Date(),"_apruebo.rds")))
rechazo %>% write_rds(here("data", str_c(Sys.Date(),"_rechazo.rds")))
