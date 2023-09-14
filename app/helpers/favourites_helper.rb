module FavouritesHelper
  def fave_or_unfave_button(movie, fave)
    if fave
      button_to '♡ Unfavourite', movie_favourite_path(movie, fave), method: :delete
    else
      button_to '♥️ Favourite', movie_favourites_path(movie)
    end
  end
end
