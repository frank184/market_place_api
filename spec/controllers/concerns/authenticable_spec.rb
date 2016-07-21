require 'rails_helper'

class Authentication
  include Authenticable
  def request;end
  def response;end
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before do
      @user = create :user
      request.headers["Authorization"] = @user.token
      allow(authentication).to receive(:request).and_return(request)
    end
    it "returns the user from the authorization header" do
      expect(authentication.current_user.token).to eql @user.token
    end
  end

  describe "#authenticate_with_token!" do
    before do
      @user = create :user
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({"errors": "Not authenticated"}.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "render a json error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end

    it { is_expected.to respond_with 401 }
  end

end
