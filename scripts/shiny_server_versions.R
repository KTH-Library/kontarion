library(dplyr)
library(httr)

rstudio_downloads <- function() {

  servers <- sprintf("https://download%s.rstudio.org", 1:3)

  wls <- function(x)
    httr::content(httr::GET(x), encoding = "UTF-8")

  get_key <- function(xml, xpath)
    xml2::xml_find_all(xml2::xml_ns_strip(xml), xpath) |>
    xml2::xml_text()

  ls_bucket <- function(server) {

    s1 <-
      server |>
      wls()

    tibble::tibble(
      loc = server,
      key = get_key(s1, "//Key"),
      ts = get_key(s1, "//LastModified"),
      sz = get_key(s1, "//Size")
    )

  }

  servers |>
    purrr::map_df(ls_bucket) |>
    dplyr::mutate(ts = lubridate::parse_date_time(ts, orders = "ymdHMS"))


}

rd <- rstudio_downloads()

shiny_server_latest_download <- function(
    flavor = c("ubuntu", "redhat-centos", "suse"),
    quiet = TRUE) {

  variant <- match.arg(flavor)
  url <- sprintf("https://www.rstudio.com/products/shiny/download-server/%s/", variant)
  if (!quiet) message("Scraping ", url, " for shiny server download location")

  location <-
    httr::content(httr::GET(url)) %>%
    xml2::xml_find_all("//pre") %>%
    xml2::xml_text() %>%
    .[grep("https://download\\d+.*", .)] %>%
    gsub(".*?(https://.*?)\\n.*$", "\\1", .)

  version <- gsub(".*?(\\d+.\\d+.\\d+.\\d+).*", "\\1", location)
  setNames(location, version)

}

#shiny_server_latest_download()
#shiny_server_latest_download("redhat")
#shiny_server_latest_download("suse")

# mismatch with VERSION file
"https://download3.rstudio.org/ubuntu-18.04/x86_64/VERSION" %>%
  GET(.) %>%
  content(as = "text", encoding = "UTF-8") %>%
  gsub("\\n", "", .)




