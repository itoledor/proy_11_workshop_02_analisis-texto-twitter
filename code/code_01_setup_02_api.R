api <- list(app_name        = "Chilean_Politics",
            consumer_key    = "BnykNLmLIHx8ZhGjDpqLTwXCd",
            consumer_secret = "RhMQ1nbALUFelx9XQudIEZNGYmGW9XCxU7z1BajZ5bQauhebqc",
            access_token    = "1569650100-7KbAb5JqXudo5GELuKd49jHfFnqv1Ii0iMzPEMy",
            access_secret   = "R14lJxlY3QRRWOGcn5gRo9Gbn8KDOro6t3gSfnhISTEWb" )

write_rds(api, here("data","api.rds"))