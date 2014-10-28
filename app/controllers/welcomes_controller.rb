class WelcomesController < ApplicationController
  def home
    if current_user
      render 'welcomes/list'
    else
      render 'welcomes/splash'
    end
  end
end
