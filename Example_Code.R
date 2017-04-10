# Monthly median home listing, sale price per square foot, and
#      number of units sold for 2984 counties in the contiguous United
#      States From 2008 to January 2016, harvested from Quandl's Zillow
#      Housing Data <URL: https://www.quandl.com/collections/housing>.
#      Provided from Quandl with rights to distribute without
#      restriction.
library(trelliscope)
library(datadr)
library(housingData)

library(magrittr)
library(dplyr)
library(tidyr)
library(ggplot2)

# qplot(time, medListPriceSqft, data = subset(housing, state == "CT"), geom = c("point", "smooth")) + facet_wrap(~ county)

# divide housing data by county and state
divide(housing, by = c("county", "state")) %>%
  drFilter(function(x){nrow(x) > 10}) ->
  # drFilter(function(x){nrow(x) > 120}) ->
  by_county


by_county %>%
  drLapply(function(x){
    range(x[,c("medListPriceSqft")], na.rm = TRUE)
  }) %>%
  as.list() %>%
  lapply("[[", 2) %>%
  unlist() %>%
  range() ->
  y_ranges



simple_cog <- function(x) {
   zillow_string <- gsub(" ", "-", do.call(paste, getSplitVars(x)))
   list(
      mean_list = cogMean(x$medListPriceSqft),
      nObs_list = cog(
        length(which(!is.na(x$medListPriceSqft))),
        desc = "number of non-NA list prices"
      ),
      zillow_href = cogHref(
        sprintf("http://www.zillow.com/homes/%s_rb/", zillow_string),
        desc = "zillow link"
      )
   )
}



simple_panel <- function(subset) {
  subset %>%
    ggplot(aes(x = time, y = medListPriceSqft)) +
      geom_smooth(method = "loess") +
      geom_point() +
      ylim(
        c(
          min(
            c(subset$medListPriceSqft, 0),
            na.rm = TRUE
          ),
          max(subset$medListPriceSqft, na.rm = TRUE)
        )
      ) +
      labs(
        x = "List Price",
        y = "Price / Sq. Ft."
      )
}

unlink("vdb", recursive = TRUE)
makeDisplay(
  by_county,
  group   = "fields",
  panelFn = simple_panel,
  cogFn   = simple_cog,
  name    = "Regular Example",
  desc    = "List and sold price over time w/ggplot2",
  conn    = vdbConn("vdb", autoYes = TRUE)
)



advanced_cog <- function(x) {
  zillow_string <- gsub(" ", "-", do.call(paste, getSplitVars(x)))

  model <- loess(medListPriceSqft ~ as.numeric(time), data = subset(x, !is.na(medListPriceSqft)))
  residuals <- model$residuals
  #  ks_test <- ks.test(residuals, "pnorm")
  #  is_normal_dist <- ks_test$p.value
   list(
    # intercept = cog(
    #    coef(model)[1],
    #    desc = "list price intercept"
    # ),
    # slope = cog(
    #   coef(model)[2],
    #   desc = "list price slope"
    # ),
    # rmse = cog(
    #   sqrt(mean(residuals * residuals)),
    #   desc = "root mean squared error"
    # ),
    # r_square = cog(
    #   summary(model)$r.squared,
    #   desc = "r square statistic | goodness of fit"
    # ),
    # ks_normal = cog(
    #   is_normal_dist,
    #   desc = "residuals are normally distributed"
    # ),
    res_std_err = cog(
      model$s,
      desc = "residual standard error"
    ),
    enp = cog(
      model$enp,
      desc = "effective number of parameters"
    ),
    mean_list = cogMean(x$medListPriceSqft),
    n_obs_list = cog(
      length(which(!is.na(x$medListPriceSqft))),
      desc = "number of non-NA list prices"
    ),
    zillow_href = cogHref(
      sprintf("http://www.zillow.com/homes/%s_rb/", zillow_string),
      desc = "zillow link"
    )
  )
}


advanced_cog <- function(x) {
  zillow_string <- gsub(" ", "-", do.call(paste, getSplitVars(x)))

  model <- loess(medListPriceSqft ~ as.numeric(time), data = subset(x, !is.na(medListPriceSqft)))
  residuals <- model$residuals
   list(
    res_std_err = cog(model$s, desc = "residual standard error"),
    enp = cog(model$enp, desc = "effective number of parameters"),
    mean_list = cogMean(x$medListPriceSqft),
    n_obs_list = cog(
      length(which(!is.na(x$medListPriceSqft))),
      desc = "number of non-NA list prices"
    ),
    zillow_href = cogHref(
      sprintf("http://www.zillow.com/homes/%s_rb/", zillow_string),
      desc = "zillow link"
    )
  )
}


makeDisplay(
  by_county,
  group   = "fields",
  panelFn = simple_panel,
  cogFn   = advanced_cog,
  name    = "Advanced Example",
  desc    = "List and sold price over time w/ggplot2",
  conn    = vdbConn("vdb")
)



view()


# http://127.0.0.1:54321/#name=Regular_Example&group=fields&layout=nrow:3,ncol:5&filter=state:(select:AZ)&labels=county,state
