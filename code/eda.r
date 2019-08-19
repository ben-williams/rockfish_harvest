# load ----

source("code/helper.r")

# data ----

dsr <- read_csv("data/dsr_adfg_1985-1999_v1.csv")
dsr1 <- read_csv("data/dsr_adfg_2000-2018_v1.csv")
psr <- read_csv("data/psr_adfg_1985-1999_v1.csv")
psr1 <- read_csv("data/psr_adfg_2000-2018_v1.csv")

bind_rows(dsr, dsr1, psr, psr1) %>% 
  rename_all(tolower) %>% 
  dplyr::select(cfec = `cfec fishery code`,
         pfshy = `permit serial number`,
         weight = `whole weight (sum)`,
         species = `species code`,
         port, 
         adfg,
         date = `date of landing` ) %>% 
    mutate(date = mdy_hm(date)) -> data

data %>% 
  ggplot(aes(date, weight)) + 
  geom_point()
  
  
data %>% 
  filter(species==145, weight<500) %>% 
  ggplot(aes(weight, fill = port)) + 
  geom_density(alpha = .2)

View(dsr)

unique(dsr$Port)

