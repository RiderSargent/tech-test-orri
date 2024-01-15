require 'rails_helper'

# RSpec.describe "GithubUsers", type: :request do
RSpec.describe GithubUsersController, type: :controller do
  let!(:gh_user_one) { FactoryBot.create(:github_user, username: 'test_gh_user_one') }
  let!(:gh_user_two) { FactoryBot.create(:github_user, username: 'test_gh_user_two') }

  describe 'GET #index' do
    it 'assigns @github_users with all Github users' do
      get :index

      expect(assigns(:github_users)).to eq([gh_user_one, gh_user_two])
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: gh_user_one.id }

      expect(response).to render_template(:show)
    end

    it 'assigns @github_user with the requested Github user' do
      get :show, params: { id: gh_user_one.id }

      expect(assigns(:github_user)).to eq(gh_user_one)
    end

    it 'redirects to index with an alert if Github user is not found' do
      get :show, params: { id: 'nonexistent_id' }

      expect(response).to redirect_to(:github_users)
      expect(flash[:alert]).to eq('Github User not found')
    end
  end

  describe 'GET #new' do
    it 'assigns @github_user as a new GithubUser instance' do
      get :new

      expect(assigns(:github_user)).to be_a_new(GithubUser)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:new_gh_user) { FactoryBot.create(:github_user, username: 'valid_username') }

      it 'calls #create_from_github_username and redirects to show' do
        allow(GithubUser).to receive(:create_from_github_username).and_return(new_gh_user)

        post :create, params: { github_user: { username: new_gh_user.username } }

        expect(response).to redirect_to(new_gh_user)
        expect(flash[:notice]).to eq('Github User created successfully.')
      end
    end

    context 'with invalid parameters' do
      it 'redirects to new with an alert if GithubUser::InvalidGithubUserError is raised' do
        allow(GithubUser).to receive(:create_from_github_username).and_raise(GithubUser::InvalidGithubUserError)

        post :create, params: { github_user: { username: 'invalid_username' } }

        expect(response).to redirect_to(:new_github_user)
        expect(flash[:alert]).to eq('Unable to create Github User - Please try again.')
      end
    end
  end
end
