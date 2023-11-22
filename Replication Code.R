rm(list=ls()) # Clearing environment

ipak <- function(pkg){ # Function for installing and loading packages
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}
packages <- c("tidyverse",
              "broom",
              "gapminder")
ipak(packages)

gapminder <- gapminder

## (1) GDP and Life Expectancy in 2007
gapminder_2007 <- gapminder |>
  filter(year == 2007)
ggplot(data=gapminder_2007, aes(x=gdpPercap, y=lifeExp, size=pop)) +
  geom_point()

gapminder <- gapminder |>
  mutate(log.gdpPercap = log10(gdpPercap))
gapminder_2007 <- gapminder |>
  filter(year == 2007) |>
  mutate(weight = pop / sum(pop))
ggplot(data=gapminder_2007, aes(x=log.gdpPercap, y=lifeExp)) +
  geom_point(aes(size=pop)) +
  geom_smooth(aes(weight=weight), method="loess", formula="y~x", col="red") +
  ggtitle("Figure 1. Life Expectancy vs. GDP per Capita (Logged)") +
  scale_y_continuous("Life Expectancy") +
  scale_x_continuous("GDP per Capita (Logged)") +
  scale_size_continuous("Population")
cor(gapminder_2007$lifeExp, gapminder_2007$log.gdpPercap)

ggplot(data=gapminder_2007, aes(x=log.gdpPercap, y=lifeExp)) +
  geom_point(aes(size=pop)) +
  facet_wrap(~ continent) +
  geom_smooth(data=filter(gapminder_2007, continent != "Oceania"), aes(weight=weight), method="loess", formula="y~x", col="red") +
  ggtitle("Figure 2. Life Expectancy vs. GDP per Capita (Logged) by Continent") +
  scale_y_continuous("Life Expectancy") +
  scale_x_continuous("GDP per Capita (Logged)") +
  scale_size_continuous("Population") 

## (2) Life Expectancy over Time by Continent
gapminder |>
  group_by(continent, year) |>
  mutate(weight = pop / sum(pop)) |>
  summarise(avg.lifeExp = weighted.mean(lifeExp, weight)) |>
  ggplot(aes(x=year, y=avg.lifeExp)) +
  geom_point(aes(color=continent)) +
  geom_line(aes(color=continent)) +
  ggtitle("Figure 3. Average Life Expectancy vs. Year") +
  scale_x_continuous("Year") +
  scale_y_continuous("Average Life Expectancy (Weighted)") +
  scale_color_discrete("Continent")

africa.lifeExp.2007 <- filter(gapminder, continent == "Africa", year == 2007) |>
  mutate(lifeExp.2007 = lifeExp) |>
  select(country, lifeExp.2007) 
africa.lifeExp.1987 <- filter(gapminder, continent == "Africa", year == 1987) |>
  mutate(lifeExp.1987 = lifeExp) |>
  select(country, lifeExp.1987)
africa.lifeExp.difference <- inner_join(africa.lifeExp.1987, africa.lifeExp.2007, by="country") |>
  mutate(difference = lifeExp.2007 - lifeExp.1987)
summary(africa.lifeExp.difference$difference)
arrange(africa.lifeExp.difference, difference)

## (3) Changes in the relationship between GDP and life expectancy over time
gapminder$decade <- rep(NA, nrow(gapminder))
gapminder$decade[gapminder$year == 1952 | gapminder$year == 1957] <- "1950's"
gapminder$decade[gapminder$year == 1962 | gapminder$year == 1967] <- "1960's"
gapminder$decade[gapminder$year == 1972 | gapminder$year == 1977] <- "1970's"
gapminder$decade[gapminder$year == 1982 | gapminder$year == 1987] <- "1980's"
gapminder$decade[gapminder$year == 1992 | gapminder$year == 1997] <- "1990's"
gapminder$decade[gapminder$year == 2002 | gapminder$year == 2007] <- "2000's"
gapminder$decade <- factor(gapminder$decade)

gapminder |>
  filter(country != "Kuwait") |>
  group_by(decade) |>
  mutate(weight = pop / sum(pop)) |>
  ungroup(decade) |>
  ggplot(aes(x=log.gdpPercap, y=lifeExp, color=decade)) +
  geom_point(alpha=0.2) +
  geom_smooth(aes(weight=weight), method="loess", formula="y~x", se=F) +
  ggtitle("Figure 4. Life Expectancy vs. GDP per Capita by Decade") +
  scale_y_continuous("Life Expectancy") +
  scale_x_continuous("GDP per Capita (Logged)") +
  scale_color_discrete("Decade") +
  labs(caption = "*Excluding Kuwait")

gapminder |>
  filter(country != "Kuwait", continent != "Oceania") |>
  group_by(decade) |>
  mutate(weight = pop / sum(pop)) |>
  ungroup(decade) |>
  ggplot(aes(x=log.gdpPercap, y=lifeExp, color=decade)) +
  geom_point(alpha=0.2) +
  facet_wrap(~ continent) +
  geom_smooth(aes(weight=weight), method="loess", formula="y~x", se=F) +
  ggtitle("Figure 5. Life Expectancy vs. GDP per Capita by Decade, Faceted by Continent") +
  scale_y_continuous("Life Expectancy") +
  scale_x_continuous("GDP per Capita (Logged)") +
  scale_color_discrete("Decade") +
  labs(caption= "*Excluding Kuwait and Oceania")

## Models
gapminder <- gapminder |>
  group_by(year) |>
  mutate(weight = pop / sum(pop)) |>
  ungroup(year) |>
  mutate(weight = weight / 12) #So that the weights sum to 1

no_africa_model <- lm(lifeExp ~ log.gdpPercap + year*continent,
                      data=filter(gapminder, continent != "Africa"),
                      weights=weight)

africa_model <- loess(lifeExp ~ log.gdpPercap + year,
                      data=filter(gapminder, continent == "Africa"),
                      weights=weight,
                      span=.35)

summary(no_africa_model)

## Appendix

filter(gapminder, country != "China") |>
  group_by(continent, year) |>
  mutate(weight = pop / sum(pop)) |>
  summarise(avg.lifeExp = weighted.mean(lifeExp, weight)) |>
  ggplot(aes(x=year, y=avg.lifeExp)) +
  geom_point(aes(color=continent)) +
  geom_line(aes(color=continent)) +
  ggtitle("Figure A1. Average Life Expectancy vs. Year (Omitting China)") +
  scale_x_continuous("Year") +
  scale_y_continuous("Average Life Expectancy (Weighted)") +
  scale_color_discrete("Continent")

gapminder |>
  group_by(decade) |>
  mutate(weight = pop / sum(pop)) |>
  ungroup(decade) |>
  ggplot(aes(x=log.gdpPercap, y=lifeExp, color=decade)) +
  geom_point(alpha=0.2) +
  geom_smooth(aes(weight=weight), method="loess", formula="y~x", se=F) +
  ggtitle("Figure A2. Life Expectancy vs. GDP per Capita by Decade (Including Kuwait)") +
  scale_y_continuous("Life Expectancy") +
  scale_x_continuous("GDP per Capita (Logged)") +
  scale_color_discrete("Decade")

augment(no_africa_model) |>
  ggplot(aes(x=.fitted, y=.resid)) +
  geom_point() +
  geom_smooth(method="loess", formula="y~x", col="red") +
  labs(title="Figure A3. Linear Model (No Africa) Linearity Check",
       y="Residuals",
       x="Fitted Values")

augment(no_africa_model) |>
  ggplot(aes(x=.fitted, y=.resid^2)) +
  geom_point() +
  geom_smooth(method="loess", formula="y~x", col="red") +
  labs(title="Figure A4. Linear Model (No Africa) Constant Variance Check",
       y="Squared Residuals",
       x="Fitted Values")

augment(no_africa_model) |>
  ggplot(aes(sample=.std.resid)) +
  stat_qq() +
  geom_abline(intercept=0, slope=1) +
  labs(title="Figure A5. Linear Model (No Africa) Normality Check",
       y="Standardized Residuals",
       x="Theoretical Quantiles")

augment(no_africa_model) |>
  ggplot(aes(x=.hat, y=.std.resid)) +
  geom_point() +
  geom_abline(intercept=0, slope=0) +
  labs(title="Figure A6. Linear Model (No Africa) Outlier Check",
       y="Standardized Residuals",
       x="Leverage")

augment(africa_model) |>
  ggplot(aes(x=.fitted, y=.resid)) +
  geom_point() +
  geom_smooth(method="loess", formula="y~x", col="red") +
  labs(title="Figure A7. LOESS Model (Africa Only) Residual Plot",
       y="Residuals",
       x="Fitted Values")

augment(africa_model) |>
  ggplot(aes(sample=scale(.resid))) +
  stat_qq() +
  geom_abline(intercept=0, slope=1) +
  labs(title="Figure A8. LOESS Model (Africa Only) Residual Q-Normal Plot",
       y="Standardized Residuals",
       x="Theoretical Quantiles")

augment(africa_model) |>
  ggplot(aes(x=log.gdpPercap, y=.fitted)) +
  geom_point() +
  geom_smooth(method="loess", formula="y~x", col="red", se=F) +
  labs(title="Figure A9. LOESS Model (Africa Only) Fitted Values vs. GDP",
       y="Fitted Values",
       x="GDP per Capita (Logged)")
