class HomeController < ApplicationController
  before_action :authenticate_user!, only: :token

  def token
  end

  def index
  end
end
