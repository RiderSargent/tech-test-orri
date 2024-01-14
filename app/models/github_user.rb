class GithubUser < ApplicationRecord
  class InvalidGithubUserError < StandardError; end

  has_many :repos, dependent: :destroy

  validates :username, presence: true, uniqueness: true

  class << self
    def create_from_github_username(username)
      repos = fetch_repos(username)
      ghu = create!(username: username)

      repos.each do |repo|
        ghu.repos.create!(
          name: repo['name'],
          stars: repo['stargazers_count'],
          language: repo['language']
        )
      end

      ghu
    end

    def fetch_repos(username)
      url = "/users/#{username}/repos"

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

      repos
    rescue Faraday::ResourceNotFound
      raise InvalidGithubUserError
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
end
