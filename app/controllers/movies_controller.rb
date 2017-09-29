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
    
    if @is_checked == nil
      @is_checked = Movie.init_is_rating_checked
    end
    
    @movies = Movie.all
    
    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]
    end
    
    if params.has_key?(:sort_by)
      session[:sort_by] = params[:sort_by]
    end
    
    check_for_redirect()
    
    if session.has_key?(:ratings)
      filter_movies(session[:ratings])
    end
    
    if session.has_key?(:sort_by)
      sort_movies(session[:sort_by])
    end
    
  end
  
  def check_for_redirect
    if (session.has_key?(:ratings) ^ params.has_key?(:ratings)) || (session.has_key?(:sort_by) ^ params.has_key?(:sort_by))
      new_params = Hash.new
      new_params[:ratings] = session[:ratings]
      new_params[:sort_by] = session[:sort_by]
      
      flash.keep
      
      redirect_to movies_path(new_params)
    end
  end
  
  def filter_movies(ratings)
    @is_checked = Movie.is_rating_checked(session[:ratings])
    keys = session[:ratings].keys
    @movies = Movie.where(rating: keys)
  end
  
  def sort_movies(sort_by)
    if sort_by == "title"
      @movies = @movies.sort {|a, b| a.title <=> b.title}
      @hilite_title = "hilite"
      @hilite_release_date = ""
    else
      @movies = @movies.sort {|a, b| a.release_date <=> b.release_date}
      @hilite_title = ""
      @hilite_release_date = "hilite"
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
