class UsersController < ApplicationController
  after_action :track_action, only: :create

  PLACEHOLDER_SEARCH_TERM = "Tuple pairing"

  def new
    @placeholder_search_term = cookies[:search_term] || PLACEHOLDER_SEARCH_TERM
    @user = User.new
    @user.search_terms.build
  end

  def create
    user = User.new(search_term_params)
    @search_term = user.search_terms.last.name

    if user.save
      flash[:notice] = "Thanks, we'll send you an email when '#{@search_term}' is namedropped in a podcast."
      redirect_to root_path
    else
      flash.now[:error] = "Could not save search term"
      render :new
    end
  end

  private

  def track_action
    ahoy.track "Submit search term", request.path_parameters.merge(search_term: @search_term)
  end

  def search_term_params
    params.require(:user).permit(:email, search_terms_attributes: [:name])
  end
end
