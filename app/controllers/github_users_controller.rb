class GithubUsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @github_users = GithubUser.all
  end

  def show
    @github_user = GithubUser.find(params[:id])
  end

  def create
    # TODO: Create the GithubUser, repos, number of stars, and language breakdown
    # @github_user = GithubUser.create(github_user_params)

    github_user_name = params[:username]

    url = "/users/#{github_user_name}/repos"

    repos = []
    page = 1

    loop do
      response = conn.get(url) do |req|
        req.params['page'] = page
        req.params['per_page'] = 100
      end

      break if response.body.empty?

      page += 1
      repos += response.body
    end

    render json: repos
  end

  private

  def github_user_params
    params.require(:github_user).permit(:username)
  end

  def conn
    options = {
      url: 'https://api.github.com',
      headers: { 'X-GitHub-Api-Version' => '2022-11-28' }
    }

    @conn ||= Faraday.new(options) do |builder|
      builder.request :authorization, 'Bearer', -> { ApiToken.find_by(name: 'github').token }
      builder.request :json
      builder.response :json
      builder.response :raise_error
    end
  end
end
