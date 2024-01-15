require 'rails_helper'

RSpec.describe GithubUser, type: :model do
  let(:gh_user_one) { FactoryBot.create(:github_user, username: 'test_gh_user_one') }
  let!(:gh_user_repo_one) { FactoryBot.create(:repo, github_user: gh_user_one, stars: 5, language: 'Ruby') }
  let!(:gh_user_repo_two) { FactoryBot.create(:repo, github_user: gh_user_one, stars: 10, language: 'Go') }
  let!(:gh_user_repo_three) { FactoryBot.create(:repo, github_user: gh_user_one, stars: 2, language: 'Ruby') }

  let(:gh_user_two) { FactoryBot.create(:github_user, username: 'test_gh_user_two') }
  let!(:gh_user_repo_four) { FactoryBot.create(:repo, github_user: gh_user_two, stars: 3, language: 'Python') }
  let!(:gh_user_repo_five) { FactoryBot.create(:repo, github_user: gh_user_two, stars: 7, language: 'Python') }
  let!(:gh_user_repo_six) { FactoryBot.create(:repo, github_user: gh_user_two, stars: 12, language: 'TypeScript') }

  describe '#stars' do
    it "returns the sum of stars for the user's repos" do
      expect(gh_user_one.stars).to eq(17)
    end
  end

  describe '#languages' do
    it "returns an array of unique languages used in the user's repos" do
      expect(gh_user_one.languages).to match_array(['Ruby', 'Go'])
    end
  end

  describe '#has_ruby?' do
    it 'returns true if the user has repos with Ruby language' do
      expect(gh_user_one.has_ruby?).to eq(true)
    end

    it 'returns false if the user has no repos with Ruby language' do
      expect(gh_user_two.has_ruby?).to eq(false)
    end
  end

  describe '#has_python?' do
    it 'returns true if the user has repos with Python language' do
      expect(gh_user_two.has_python?).to eq(true)
    end

    it 'returns false if the user has no repos with Python language' do
      expect(gh_user_one.has_python?).to eq(false)
    end
  end

  describe '#has_golang?' do
    it 'returns true if the user has repos with Go language' do
      expect(gh_user_one.has_golang?).to eq(true)
    end

    it 'returns false if the user has no repos with Go language' do
      expect(gh_user_two.has_golang?).to eq(false)
    end
  end

  describe '#has_typescript?' do
    it 'returns true if the user has repos with TypeScript language' do
      expect(gh_user_two.has_typescript?).to eq(true)
    end

    it 'returns false if the user has no repos with TypeScript language' do
      expect(gh_user_one.has_typescript?).to eq(false)
    end
  end

  describe '.create_from_github_username' do
    it 'creates a GithubUser with associated repos' do
      expect(GithubUser).to receive(:fetch_repos).with('testuser').and_return([])

      expect { GithubUser.create_from_github_username('testuser') }.to change(GithubUser, :count).by(1)
    end

    it 'raises InvalidGithubUserError when user is not found on Github' do
      allow(GithubUser).to receive(:fetch_repos).and_raise(Faraday::ResourceNotFound)

      expect { GithubUser.create_from_github_username('nonexistentuser') }.to raise_error(GithubUser::InvalidGithubUserError)
    end
  end

  describe '.fetch_repos' do
    # TODO: Install VCR gem and record a cassette for this test
    xit 'returns an array of repos for a given username' do
      VCR.use_cassette('github_user_repos') do
        expect(GithubUser.fetch_repos('testuser')).to be_an(Array)
      end
    end
  end
end
