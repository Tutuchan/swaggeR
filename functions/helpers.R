getTournament <- function(id = NULL, url = mainURL){
  url_ = paste0(url, "tournament.json")
  if(!missing(id)) url_ <- paste0(url, "tournament/", id, ".json")
  fromJSON(url_)
}

getLeague <- function(id = NULL, url = mainURL){
  url_ = paste0(url, "league.json?parameters[method]=all&parameters[published]=1")
  if(!missing(id)) url_ <- paste0(url, "league/", id, ".json")
  fromJSON(url_)
}

getSeries <- function(id = NULL, url = mainURL){
  url_ = paste0(url, "series.json")
  if(!missing(id)) url_ <- paste0(url, "series/", id, ".json")
  fromJSON(url_)
}