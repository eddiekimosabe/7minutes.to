class ProfileController < ApplicationController
  def edit

  end

  def oauth
    redirect_to "https://getpocket.com/auth/authorize?request_token=#{current_user.request_token}&redirect_uri=#{"http://0.0.0.0:3000/success"}"
  end

  def complete_oauth
    current_user.oauthd
  end
end
