class GithubUsersController < ApplicationController
  def index
    @github_users = GithubUser.all
  end

  def show
    # @github_user = GithubUser.find(params[:id])

    github_user = params[:id]
    url = "/users/#{github_user}/repos"

    response = conn.get(url) do |req|
      req.params['page'] = 1
      req.params['per_page'] = 100
    end

    render json: response.body
  end

  private

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
