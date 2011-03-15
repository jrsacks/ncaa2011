ActionController::Routing::Routes.draw do |map|
  map.root :controller => "teams", :action => "sorted"
  map.resources :teams

  map.connect 'players/team/:teamAbbrev',  :controller => "players", :action => "team"

  map.resources :players

  map.connect 'scores/date/:date',  :controller => "scores", :action => "date"
  map.connect 'scores/games/:gameId',  :controller => "scores", :action => "game"
  map.resources :scores
end
