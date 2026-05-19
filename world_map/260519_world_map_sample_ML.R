
install.packages("ggplot2") # most of heavylifting
install.packages("maps") # map data
library(ggplot2)
library(maps)

# long/lat of points along country borders, classified by region
world_coordinates <- map_data("world") # coordinates for all countries in the world


###simple map
map1<-ggplot() + 
  geom_map( 
    data = world_coordinates, map = world_coordinates, 
    aes(long, lat, map_id = region),
    color = "black", fill = "forestgreen", linewidth = 0.2) # black lines
map1

###fill in sea and remove axis
map2<-ggplot() + 
  geom_map( 
    data = world_coordinates, map = world_coordinates, 
    aes(long, lat, map_id = region), # aesthetics, maps variables to visual properties
    color = "black", fill = "lightgreen", linewidth = 0.2 )+
  theme(panel.background = element_rect(fill = "lightblue"), # fill all the background 
        panel.grid.minor = element_line(color="lightblue"),
        panel.grid.major= element_line(color="lightblue"),
        axis.title.x=element_blank(), # get rid of all axis labels
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
map2

# extract data file
df <- read.csv("C:/Users/Equipo/Documents/ss_ML/260519_world_map_capital_cities_ML.csv")
df$populationscaled<-df$population/1000000


#plot cities as simple points
map3<-map2 +
  geom_point( # add points
    data = df, 
    aes(x=lng, y=lat),  color = "darkred", 
    size = .5, alpha = 1) # alpha is transparency
map3

###plot data based on value (size of city)
map4<-map2 +
geom_point( 
  data = df, 
  aes(lng, lat, color = populationscaled), size=1.2,  
  alpha = 1) +scale_color_gradient(low="darkblue",
                          high="red", space ="Lab",(title="Population (millions)")) # perceptually uniform colour space
map4



    