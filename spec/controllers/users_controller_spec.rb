require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  let(:search_term) { 'Rip Tide' }

  describe 'GET new' do
    it 'sets the user instance variables' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    context 'the cookie contains a previous search term' do
      before do
        request.cookies[:search_term] = search_term
      end

      it 'reads the placeholder search term from the cookie' do
        get :new
        expect(assigns(:placeholder_search_term)).to eq(search_term)
      end
    end

    context 'when the cookie does not contain a previous search term' do
      it 'uses a placeholder search term' do
        get :new
        expect(assigns(:placeholder_search_term)).to eq(UsersController::PLACEHOLDER_SEARCH_TERM)
      end
    end
  end

  describe 'POST create' do
    let(:user) { instance_double('User', :user, search_terms: search_terms) }
    let(:search_terms) { instance_double('Search Term', :search_term, build: nil, last: double(:last, name: search_term)) }
    let(:mail) { double(:mail, deliver_later: nil) }

    before do
      allow(User).to receive(:new).and_return(user)
      allow(UserRegistrationMailer).to receive(:search_term_submitted_email).with(user, search_term).and_return(mail)
    end

    context 'successful submission' do
      before do
        allow(user).to receive(:save).and_return(true)
      end

      it 'saves the user' do
        expect(user).to receive(:save).and_return(true)
        post :create, params: { user: {"search_terms_attributes"=>{"0"=>{"name"=>"Rip Tide"}}, "email"=>"example@domain.com"} }
      end

      it 'sets the flash notice' do
        post :create, params: { user: {"search_terms_attributes"=>{"0"=>{"name"=>"Rip Tide"}}, "email"=>"example@domain.com"} }
        expect(flash[:notice]).to eq("Thanks, we'll send you an email when '#{search_term}' is namedropped in a podcast.")
      end

      it 'sends an email as a confirmation' do
        expect(UserRegistrationMailer).to receive(:search_term_submitted_email).with(user, search_term)
        post :create, params: { user: {"search_terms_attributes"=>{"0"=>{"name"=>"Rip Tide"}}, "email"=>"example@domain.com"} }
      end

      it 'redirects to the root path' do
        post :create, params: { user: {"search_terms_attributes"=>{"0"=>{"name"=>"Rip Tide"}}, "email"=>"example@domain.com"} }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'unsuccessful submission' do
      before do
        allow(user).to receive(:save).and_return(false)
      end

      it 'sets the flash error' do
        post :create, params: { user: {"search_terms_attributes"=>{"0"=>{"name"=>"Rip Tide"}}, "email"=>"example@domain.com"} }
        expect(flash[:error]).to eq("Could not save search term")
      end

      it 'renders the new template' do
        post :create, params: { user: {"search_terms_attributes"=>{"0"=>{"name"=>"Rip Tide"}}, "email"=>"example@domain.com"} }
        expect(response).to render_template(:new)
      end
    end
  end
end
