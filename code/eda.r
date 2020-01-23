# load ----

source("code/helper.r")

# data ----

dsr <- read_csv("data/dsr_adfg_1985-1999_v1.csv")
dsr1 <- read_csv("data/dsr_adfg_2000-2018_v1.csv")
psr <- read_csv("data/psr_adfg_1985-1999_v1.csv")
psr1 <- read_csv("data/psr_adfg_2000-2018_v1.csv")
# species <- read_csv("data/Species_LUT.csv")

# cleanup data ----------------

# species %>% 
#   rename_all(tolower) %>% 
#   filter(species_code %in% c(138,142,145,147,148,149,154,155,156,157,169,172,173)) %>% 
#   group_by(species_code, species_common) %>% 
#   tally()


# organize data -----

bind_rows(dsr, dsr1, psr, psr1) %>% 
  rename_all(tolower) %>% 
  dplyr::select(cfec = `cfec fishery code`,
                fishery = `fishery name`,
                pfshy = `permit serial number`,
                weight = `whole weight (sum)`,
                species = `species code`,
                port, 
                adfg,
                date = `date of landing`,
                waters,
                gstat = `stat area`) %>% 
    mutate(date = mdy_hm(date),
           year = year(date),
           species = ifelse(species == 154, 172, species),
           Species = factor(species),
           Port = factor(port)) -> data

data %>% 
  filter(waters!="FED", gstat %in% c(525801:525804)) %>% 
  group_by(Species, year, gstat) %>% 
  summarise(catch = sum(weight)) %>% 
    ggplot(aes(year, catch, color = gstat, group = gstat)) + 
  geom_point() +
  geom_line() +
  facet_wrap(~Species)

data %>% 
  filter(waters!="FED", gstat %in% c(525801:525804)) %>% 
  group_by(year, gstat, Species) %>% 
  mutate(mean = mean(weight, na.rm = T),
         sd = sd(weight, na.rm = T),
         n = n(),
         se = sd / sqrt(n)) %>% 
  ggplot(aes(year, mean, color = gstat)) + 
  geom_point() +
  geom_errorbar(aes(ymin = mean-se*2, ymax = mean+se*2)) 

# weight dol

data %>% 
  filter(gstat %in% c(525801:525804), species== 142, year==1997) %>% 
  group_by(gstat, date) %>% 
  mutate(mean = mean(weight, na.rm = T),
         sd = sd(weight, na.rm = T),
         n = n(),
         se = sd / sqrt(n)) %>% 
  ggplot(aes(date, mean, color = gstat)) + 
  geom_point() +
  geom_errorbar(aes(ymin = mean-se*2, ymax = mean+se*2)) 

