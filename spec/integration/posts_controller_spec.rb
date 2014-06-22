require 'spec_helper'

RSpec.describe PostsController, type: :controller do
  describe "POST #create" do
    context "with good parameters" do
      let(:params) { { "post" => { "title" => "Hello, world!", "body" => "Howdy!" } } }

      it "passes the validation" do
        post :create, params
        expect(response).to be_success
      end
    end

    context "with bad parameters" do
      let(:params) { { "post" => { "title" => "Hello, world!" } } }

      it "fails the validation" do
        post :create, params
        expect(response.status).to eq 400
      end
    end
  end

  describe "PUT #update" do
    context "with good parameters" do
      let(:params) { { "id" => 123, "post" => { "title" => "Hello, world!", "body" => "Howdy!" } } }

      it "passes the validation" do
        put :update, params
        expect(response).to be_success
      end
    end

    context "with bad parameters" do
      let(:params) { { "id" => 123, "post" => { "title" => "Hello, world!" } } }

      it "fails the validation" do
        put :update, params
        expect(response.status).to eq 400
      end
    end
  end
end
