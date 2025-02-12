require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:attendee) { Attendee.create!(Email: 'test@example.com', Password: 'test123', name: 'Test User', Phone_number: '1234567890', Address: '123 Test St', Credit_card_info: '0000-1111-2222-3333') }

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs the user in and redirects to the root URL" do
        post :create, params: { email_address: 'test@example.com', password: 'test123' }
        expect(session[:user_id]).to eq(attendee.id)
        expect(response).to redirect_to(root_url)
      end
    end

    context "with invalid credentials" do
      it "renders the new template with an alert" do
        post :create, params: { email_address: 'wrong@example.com', password: 'wrong' }
        expect(session[:user_id]).to be_nil
        expect(flash[:alert]).to match(/Email or password is invalid/)
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      delete :destroy
    end

    it "logs the user out" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root URL" do
      expect(response).to redirect_to(root_url)
    end
  end
end
