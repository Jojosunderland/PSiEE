install.packages("palmerpenguins")

library(ggplot2)
library(dplyr)
library(palmerpenguins)

glimpse(penguins)

### GGPLOT - HISTOGRAMS ###

# specify the aesthetic properties using aes(). In a histogram, we only have one variable on the x-axis
ggplot(penguins, aes(x = flipper_length_mm)) +
  geom_histogram()

# Change the bin width to 1 mm
ggplot(penguins, aes(x = flipper_length_mm)) + # it is common practise to put anything separated by + onto a new line. This way, you can build up the graph line by line
  geom_histogram(binwidth = 1)

## Customisation ##

# add labels (axis titles and main title)
ggplot(penguins, aes(x = flipper_length_mm)) +
  geom_histogram() +
  labs(x = "Flipper Length (mm)", y = "Frequency", title = "Histogram of flipper length")

# specify outline and each colour for the bar

ggplot(penguins, aes(x = flipper_length_mm)) +
  geom_histogram(colour = "blue", fill = "lightblue")

# colour by a categorical variable - species
ggplot(penguins, aes(x = flipper_length_mm, fill = species)) +
  geom_histogram(colour = "black") # specifying a black outline (property of the histogram not the data)

## DENSITY PLOTS 
ggplot(penguins, aes(x = flipper_length_mm, fill = species)) +
  geom_density()

#~~ Make the distributions more transparent with alpha

ggplot(penguins, aes(x = flipper_length_mm, fill = species)) +
  geom_density(alpha = 0.5)

## FACETING 
ggplot(penguins, aes(x = flipper_length_mm)) +
  geom_histogram() +
  facet_wrap(~species)

# Make the number of columns = 1 for easier comparison.

ggplot(penguins, aes(x = flipper_length_mm)) +
  geom_histogram() +
  facet_wrap(~species, ncol = 1)

# penguins dataset, with x of flipper length and fill by species +
# make a histogram with a bar for every 1mm and colour the edges black +
# label the x axis and give the plot a title +
# create facets based on species, and make them all appear in one column

ggplot(penguins, aes(x = flipper_length_mm, fill = species)) +
  geom_histogram(binwidth = 1, colour = "black") +
  labs(x = "Flipper Length (mm)", title = "Histogram of flipper length in Palmer penguins.") +
  facet_wrap(~species, ncol = 1)

## EXERCISES
# Q1 histogram of bill depth - bars by species, facet by sex and species and appropriate labels

ggplot(penguins, aes(x=bill_depth_mm, fill=species)) + 
  geom_histogram(colour = "black") + 
  labs(x = "Bill Depth (mm)", fill = "Penguin species") +
  facet_grid(species~sex)

#Q2 density plot of bill depth
penguins_subset <- subset(penguins, !is.na(sex)) # remove NAs
ggplot(penguins_subset, aes(x = bill_depth_mm, fill = sex, colour = sex)) +
  geom_density(alpha = 0.6) +
  facet_grid(~species) +
  labs(x = "Bill Depth (mm)", fill = "Sex", colour ="Sex")

# Q3 bar plot of the number of individuals of each sex within each species

ggplot(penguins_subset, aes(x=species, fill = sex)) +
  geom_bar(colour = "black", position = "dodge")+ # unstack the bars
  labs(x = "Pygoscelis Species", fill = "Sex") + 
  scale_x_discrete(labels = c("P. adeliae", "P. antarctica", "P. papua")) # labels on the axis



### GGPLOT - SCATTERPLOT ###
# We specify our data and aes() with x and y, and a new geom, geom_point()

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point()

# Add a statistical test with stat_smooth()
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  stat_smooth()

# specify we want to use linear regression
lm(bill_depth_mm ~ bill_length_mm, data = penguins)

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  stat_smooth(method = "lm")
# shaded part indicates the 95% confidence interval

# group by species
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point() +
  stat_smooth(method = "lm")

## specifying point colour
# If you type scale_colour_, you can see that there are many choices. The two that you will use for categorical functions are:
# scale_colour_manual() - here you can specify the specific colours you would like in a c() vector. 
# scale_colour_brewer() - you can specify palettes

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point() +
  scale_colour_manual(values = c("blue", "red", "purple"))

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point() +
  scale_colour_brewer(palette = "Set1")

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point()

## specifying point transparency and size
#using alpha

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point(alpha = 0.8)

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point(alpha = 0.4)

# point size
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point(alpha = 0.8, size = 3)

## Adjusting the scales 
# using scale_x_continuous() and scale_y_continuous()
# we want to specify where the breaks occur either using vector c(1,2,3) or seq(start, stop, interval) command

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point() +
  scale_x_continuous(breaks = seq(35, 60, 5))

## saving a plot
# using ggsave()
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point() +
  scale_x_continuous(breaks = seq(35, 60, 5))

ggsave("bill_morphology_plot.png") # give it a name, it will save in Working D

# save with a fixed height and width:
ggsave("bill_morphology_plot.png", width = 15, height = 10, units = "cm")

# final example graph
# penguins dataset, with x of bill length, y of bill depth, and colour by species +
# make a scatterplot with transparent points that are a bit larger +
# add linear regression lines +
# colour the points blue, red and purple +
# change the scale on the x axis to have a break every 5mm +
# label the axes and legend.

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point(alpha = 0.5, size = 3) +
  stat_smooth(method = "lm") +
  scale_colour_manual(values = c("blue", "red", "purple")) +
  scale_x_continuous(breaks = seq(35, 60, 5)) +
  labs(x = "Bill Length (mm)", y = "Bill Depth (mm)", colour = "Species")


## EXERCISE 2 ##

#Q4 scatterplot of bill depth (x) andd flipper length (y)

ggplot(penguins, aes(x=bill_depth_mm, y=flipper_length_mm, colour = bill_length_mm)) +
  geom_point() +
  scale_colour_gradient(low = "red", high = "purple") +
  scale_y_continuous(breaks=seq(170, 230, 20)) + 
  labs(x = "Bill Depth (mm)", y = "Flipper Lenght (mm)", colour = "Bill Length (mm)")


# Q5a colour points by species with different shapes
ggplot(penguins, aes(x=bill_length_mm, y=flipper_length_mm, colour = species, shape = species)) +
  geom_point() +
  scale_y_continuous(breaks=seq(170, 230, 20)) + 
  labs(x = "Bill Depth (mm)", y = "Flipper Lenght (mm)", colour = "Species", shape = "Species" )

#5b add a single regression line 


lm(bill_length_mm ~ flipper_length_mm, data = penguins)
ggplot(penguins, aes(x=bill_length_mm, y=flipper_length_mm)) +
  geom_point(aes(colour = species, shape = species)) + # need to move the colour and shape to just the geom part
  scale_y_continuous(breaks=seq(170, 230, 20)) + 
  labs(x = "Bill Depth (mm)", y = "Flipper Lenght (mm)", colour = "Species", shape = "Species" ) +
  stat_smooth(method = "lm")

#5c 
lm(bill_length_mm ~ flipper_length_mm, data = penguins)
ggplot(penguins, aes(x=bill_length_mm, y=flipper_length_mm)) +
  geom_point(aes(colour = species, shape = species)) + # need to move the colour and shape to just the geom part
  scale_y_continuous(breaks=seq(170, 230, 20)) + 
  labs(x = "Bill Depth (mm)", y = "Flipper Lenght (mm)", colour = "Species", shape = "Species" ) +
  stat_smooth(method = "lm") +
  theme_bw()

# 5d legend at top
lm(bill_length_mm ~ flipper_length_mm, data = penguins)
ggplot(penguins, aes(x=bill_length_mm, y=flipper_length_mm)) +
  geom_point(aes(colour = species, shape = species)) + # need to move the colour and shape to just the geom part
  scale_y_continuous(breaks=seq(170, 230, 20)) + 
  labs(x = "Bill Depth (mm)", y = "Flipper Lenght (mm)", colour = "Species", shape = "Species" ) +
  stat_smooth(method = "lm") +
  theme_bw() +
  theme(legend.position = "top")


### GGPLOT - BOXPLOTS ###
# geom_boxplot()

ggplot(penguins, aes(x = flipper_length_mm, fill = species)) +
  geom_density(alpha = 0.5)

ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_boxplot()

ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_boxplot(notch = T) # notch = true, visual indicator of significance betweeng groups  (overlaps = not different)

## geom_violin() ##
#boxplots are also not useful as they do not show the amount of data and the actual distribution of the underlying data
ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_violin()

# combine different geoms together to build them up as layers
# ORDER is really important
ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_violin() + 
  geom_boxplot()

#edit width to fit
ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_violin() +
  geom_boxplot(width = 0.4, notch = T)

# fill by species - need to be careful 
ggplot(penguins, aes(x = species, y = flipper_length_mm, fill = species)) +
  geom_violin() +
  geom_boxplot(width = 0.4)

# fill just the violin
ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_violin(aes(fill = species)) +
  geom_boxplot(width = 0.4, fill = "grey90", notch = T)


## geom_jitter() ##
# add the points to the boxplot to understand the amount of data, rather than it’s distribution
# What is does is randomly jitter the points along the axis of the categorical variable (species)

ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_jitter()

# Tweak width to make nicer:

ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
  geom_jitter(width = 0.3)

# add this to boxplot
ggplot(penguins, aes(x = species, y = flipper_length_mm, colour = species)) +
  geom_boxplot() + 
  geom_jitter(width = 0.3)

# Tweak the alpha values to make this look nicer - what else would you do?

ggplot(penguins, aes(x = species, y = flipper_length_mm, colour = species)) +
  geom_boxplot() + 
  geom_jitter(width = 0.3, alpha = 0.3)

## theme()
# When you want to start fiddling with the plot background, text size, alignment, etc. then you have to start exploring theme()
ggplot(penguins, aes(x = species, y = flipper_length_mm, colour = species)) +
  geom_boxplot() + 
  geom_jitter(width = 0.3, alpha = 0.3) +
  theme_bw()


## EXERCISE 3 ##

#Q6 Make a bar plot of the number of individuals of each sex within each species
ggplot(penguins_subset, aes(x=species, fill = sex)) +
  geom_bar(position = "dodge") 


