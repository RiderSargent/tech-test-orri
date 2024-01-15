class GithubUsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @github_users = GithubUser.all
  end

  def show
    @github_user = GithubUser.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :github_users, alert: 'Github User not found'
  end

  def new
    @github_user = GithubUser.new
  end

  def create
    ghu = GithubUser.create_from_github_username(github_user_params[:username])

    redirect_to ghu, notice: 'Github User created successfully.'
  rescue GithubUser::InvalidGithubUserError
    redirect_to :new_github_user, alert: 'Unable to create Github User - Please try again.'
  end

  private

  def github_user_params
    params.require(:github_user).permit(:username)
  end
end
