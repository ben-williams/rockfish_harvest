# load ----

source("code/helper.r")

# data ----

dsr <- read_csv("data/dsr_adfg_1985-1999_v1.csv")
dsr1 <- read_csv("data/dsr_adfg_2000-2018_v1.csv")
psr <- read_csv("data/psr_adfg_1985-1999_v1.csv")
psr1 <- read_csv("data/psr_adfg_2000-2018_v1.csv")

bind_rows(dsr, dsr1, psr, psr1)

View(dsr)

unique(dsr$Port)

dsr %>% 
  filter(`Whole Weight (sum)`<100, `Species Code`==145) %>% 
  ggplot(aes(`Whole Weight (sum)`)) + geom_density()
