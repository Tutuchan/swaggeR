getData <- function(type, id = NULL, url = mainURL){
  if (!type %in% c("series", "league", "tournament")) stop('incorrect type')
  if (type == "league") {
    url_ = paste0(url, "league.json?parameters[method]=all&parameters[published]=1")
    if(!is.null(id)) url_ <- paste0(url, "league/", id, ".json")
  } else {
    url_ = paste0(url, type, ".json")
    if(!is.null(id)) url_ <- paste0(url, type, "/", id, ".json")
  }
  print(url_)
  fromJSON(url_)
}


getTournament <- function(id = NULL, url = mainURL){
  getData("tournament", id, url)
}

getLeague <- function(id = NULL, url = mainURL){
  getData("league", id, url)
}

getSeries <- function(id = NULL, url = mainURL){
  getData("series", id, url)
}


getAllTeams <- function(){
  listTournaments <- getTournament()
  lapply(listTournaments, function(tournament){
    if(length(tournament$contestants) > 0) unlist(tournament$contestants) %>% 
      t %>% 
      as.data.frame %>% 
      select(ends_with("id")) %>% 
      as.numeric
  }) %>% unlist %>% as.numeric
}
