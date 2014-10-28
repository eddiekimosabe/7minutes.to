class ProfileController < ApplicationController
  def edit

  end

  def oauth
    redirect_to "https://getpocket.com/auth/authorize?request_token=#{current_user.request_oauth_token}&redirect_uri=#{"http://0.0.0.0:3000/oauth/success"}"
  end

  def success
    current_user.complete_oauth
    current_user.fetch_unread_articles_from_pocket
    # current_user.find_estimated_article_time
  end
end
