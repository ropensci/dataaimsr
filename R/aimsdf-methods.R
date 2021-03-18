#' summary.aimsdf
#'
#' @param object An object of class \code{\link{aimsdf}} as
#' returned by \code{\link{aims_data}}.
#' @param ... Unused.
#'
#' @return A list containing summary info from the input data.frame.
#'
#' @export
summary.aimsdf <- function(object, ...) {
  x <- list(
    cit = aims_citation(object),
    met = aims_metadata(object),
    pars = aims_parameters(object),
    dim = dim(object),
    type = attr(object, "type"),
    target = attr(object, "target"),
    hdf = head(data.frame(object))
  )
  target <- make_pretty_data_label(x$target)
  if (grepl("summary", x$type)) {
    x$type <- capitalise(x$type)
    cat(paste0(x$type, " from the ", target, " dataset"), sep = "")
    target
    cat("\n\n")
    cat("A data.frame with ", x$dim[1], " observations and ", x$dim[2],
        " variables:\n", sep = "")
    print(x$hdf)
    cat("...\n")
  } else {
    cat(paste0(target,
               " ", x$type, " data containing the following attributes:\n"),
        paste0("  - citation: ", x$cit, "\n"),
        paste0("  - metadata: ", x$met, "\n"),
        paste0("  - parameters: ", paste0(x$pars, collapse = "; ")),
        sep = "")
    cat("\n\n")
    cat("A data.frame with ", x$dim[1], " observations and ", x$dim[2],
        " variables:\n", sep = "")
    print(x$hdf)
    cat("...\n")
  }
  invisible(x)
}

#' print.aimsdf
#'
#' @param x An object of class \code{\link{aimsdf}} as
#' returned by \code{\link{aims_data}}.
#' @param ... Not used.
#'
#' @return A list containing a summary of the model fit as returned a
#' brmsfit for each model.
#'
#' @export
print.aimsdf <- function(x, ...) {
  NextMethod()
}

#' head.aimsdf
#'
#' @param x An object of class \code{\link{aimsdf}} as
#' returned by \code{\link{aims_data}}.
#' @param ... Not used.
#'
#' @export
head.aimsdf <- function(x, ...) {
  NextMethod()
}

#' tail.aimsdf
#'
#' @param x An object of class \code{\link{aimsdf}} as
#' returned by \code{\link{aims_data}}.
#' @param ... Not used.
#'
#' @export
tail.aimsdf <- function(x, ...) {
  NextMethod()
}

#' plot.aimsdf
#'
#' Plotting options for aimsdf objects
#'
#' @param x An object of class \code{\link{aimsdf}} as
#' returned by \code{\link{aims_data}}.
#' @param ptype Type of plot. Can either be "time_series" or "map".
#' @param pars Which parameters to plot? Only relevant if ptype is
#' "time_series"
#' @param ... Not used.
#'
#' @details Currently plots cannot be customised. Summary datasets can only
#' be represented by maps.
#'
#' @return An object of class \code{\link[ggplot2]{ggplot}}.
#'
#' @importFrom rnaturalearth ne_countries
#' @importFrom dplyr %>% mutate filter group_by summarise
#' @importFrom tidyr drop_na
#' @importFrom sf st_transform st_as_sf
#' @importFrom ggplot2 ggplot geom_sf theme_classic theme element_rect labs
#' @importFrom ggplot2 aes scale_colour_distiller guides guide_colourbar
#' @importFrom ggplot2 geom_line theme_bw element_text facet_wrap
#' @importFrom ggrepel geom_label_repel
#'
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' wdf <- aims_data("weather", api_key = NULL,
#'                  filters = list(site = "Yongala",
#'                                 from_date = "2018-01-01",
#'                                 thru_date = "2018-01-02"))
#' plot(wdf, ptype = "map")
#' plot(wdf, ptype = "time_series")
#' # summary datasets can only return maps
#' sdf <- aims_data("temp_loggers", api_key = NULL,
#'                  summary = "summary-by-deployment")
#' plot(sdf, ptype = "map")
#' }
#' @export
plot.aimsdf <- function(x, ..., ptype, pars) {
  dataset <- attr(x, "target")
  target <- make_pretty_data_label(dataset)
  d_type <- attr(x, "type")
  if (grepl("summary", d_type)) {
    if (ptype == "time_series") {
      message("Cannot plot a time series for ", d_type, " data; returning map",
              " instead")
    }
    map_bd <- ne_countries(continent = "oceania", returnclass = "sf") %>%
      st_transform(crs = 4326)
    y <- x %>%
      mutate(cols = cal_obs * 1e-3) %>%
      drop_na(lon, lat) %>%
      st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
      st_transform(crs = 4326)
    p_bkg <- make_pretty_colour("lightblue")
    name_leg <- "# Calibrated obs. (thousands)"
    ggplot(data = map_bd) +
      geom_sf(colour = "grey60", fill = "burlywood2",
              alpha = 0.8, lwd = 0.1) +
      theme_classic() +
      theme(panel.background = element_rect(fill = p_bkg, colour = p_bkg,
                                            linetype = "solid"),
            legend.pos = "bottom") +
      labs(x = "Longitude",
           y = "Latitude",
           title = target,
           subtitle = d_type) +
      geom_sf(data = y, mapping = aes(colour = cols)) +
      scale_colour_distiller(name = name_leg, palette = 6) +
      guides(colour = guide_colourbar(title.position = "top",
                                      title.hjust = 0.5))
  } else {
    if (ptype == "time_series") {
      if (missing(pars)) {
        d_pars <- aims_parameters(x)
        n_ <- min(length(d_pars), 4)
        message("argument pars is missing; returning time series for ",
                n_, " parameter(s) chosen at random; see ?aims_parameters")
        pars <- sample(d_pars)[seq_len(n_)]
      }
      y <- x %>%
        filter(parameter %in% pars)
      ggplot(data = y) +
        geom_line(mapping = aes(x = time, y = qc_val, colour = subsite)) +
        labs(x = "Date", y = "Parameter value", colour = "Subsite",
             title = target, subtitle = "Time series") +
        facet_wrap(~parameter, ncol = 2) +
        theme_bw() +
        theme(axis.title.x = element_text(size = 12),
              axis.title.y = element_text(size = 12))
    } else if (ptype == "map") {
      map_bd <- ne_countries(continent = "oceania", returnclass = "sf") %>%
        st_transform(crs = 4326)
      y_l <- x %>%
        group_by(site) %>%
        summarise(n_obs = length(qc_val), lon = unique(lon),
                  lat = unique(lat), n_ser = length(unique(series))) %>%
        mutate(par_l = paste0(site, ":\n", n_ser, " series; ", n_obs,
                              " obs.")) %>%
        drop_na(lon, lat)
      y_p <- y_l %>%
        st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
        st_transform(crs = 4326)
      y_l <- y_l %>%
        mutate(lon = extract_map_coord(y_p$geometry, 1),
               lat = extract_map_coord(y_p$geometry, 2))
      p_bkg <- make_pretty_colour("lightblue")
      name_leg <- "# Calibrated obs. (thousands)"
      ggplot(data = map_bd) +
        geom_sf(colour = "grey60", fill = "burlywood2",
                alpha = 0.8, lwd = 0.1) +
        theme_classic() +
        theme(panel.background = element_rect(fill = p_bkg, colour = p_bkg,
                                              linetype = "solid"),
              legend.pos = "bottom") +
        labs(x = "Longitude", y = "Latitude", title = target,
             subtitle = d_type) +
        geom_sf(data = y_p, colour = "grey30") +
        geom_label_repel(data = y_l, size = 3, hjust = 0, vjust = 0,
                         mapping = aes(x = lon, y = lat,
                                       label = par_l))
    }
  }
}

#' make_pretty_data_label
#'
#' Internal
#'
#' @param x A character
make_pretty_data_label <- function(x) {
  ifelse(x == "weather", "Weather Station", "Temperature loggers")
}

#' make_pretty_colour
#'
#' Internal
#'
#' @param x A character
#' @param alpha_ A numeric
#'
#' @importFrom grDevices col2rgb rgb
make_pretty_colour <- function(x, alpha_ = 0.55) {
  col <- col2rgb(x)
  rgb(col[1], col[2], col[3], alpha = alpha_ * 255, maxColorValue = 255)
}

#' capitalise
#'
#' Internal
#'
#' @param x A character
capitalise <- function(x) {
  paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
}

#' extract_map_coord
#'
#' Internal
#'
#' @param x An sfc_POINT
#' @param ... Additional argument "pos" to internal function
extract_map_coord <- function(x, ...) {
  sapply(x, function(z, pos)z[[pos]], ...)
}
