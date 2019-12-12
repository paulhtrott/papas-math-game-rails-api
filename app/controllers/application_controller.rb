class ApplicationController < ActionController::API
  before_action :check_api_key

  private

    def check_api_key
    end
end
