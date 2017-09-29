class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    
    if @is_checked = nil
      @is_checked = Movie.init_is_rating_checked
    end
    
    if params.has_key?(:ratings)
      @is_checked = Movie.is_rating_checked(params[:ratings])
      
      keys = params[:ratings].keys
      @movies = Movie.where(rating: keys)
    
    elsif params.has_key?(:sort_by)
      # sorting the movies by sort_by param
      @movies = Movie.order(params[:sort_by]).all

      # setting hilite class for css highlight
      if params[:sort_by] == "title"
        @hilite_title = "hilite"
        @hilite_release_date = ""
      else
        @hilite_title = ""
        @hilite_release_date = "hilite"
      end

    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
