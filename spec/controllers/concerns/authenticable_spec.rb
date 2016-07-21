require 'rails_helper'

class Authentication
  include Authenticable
  def request;end
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
end
