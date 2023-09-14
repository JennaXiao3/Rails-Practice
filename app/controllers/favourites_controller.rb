class FavouritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    @movie.fans << current_user
    redirect_to @movie
  end

  def destroy
    @favourite = current_user.favourites.find(params[:id])
    @favourite.destroy

    redirect_to @movie
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
