
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

         has_many :reads

  def request_oauth_token
    conn = Faraday.new('https://getpocket.com')
    post = conn.post '/v3/oauth/request', { 'consumer_key' => ENV['POCKET_CONSUMER_KEY'], 'redirect_uri' => 'localhost:3000'}, { 'X-Accept' => 'application/json' }

    @code = JSON.parse(post.body)['code']
    self.code = @code
    self.save
    return @code
  end

  def complete_oauth
    conn = Faraday.new('https://getpocket.com')
    post = conn.post 'v3/oauth/authorize', { 'consumer_key' => ENV['POCKET_CONSUMER_KEY'], 'code' => self.code }, { 'X-Accept' => 'application/json' }

    self.access_token = JSON.parse(post.body)['access_token']
    self.save
    conn = Faraday.new('https://getpocket.com')
    post = conn.post 'v3/get', { 'consumer_key' => ENV['POCKET_CONSUMER_KEY'], 'access_token' => self.access_token, "count" => "10", "detailType" => "complete", "contentType" => "article"}, { 'X-Accept' => 'application/json' }
    # puts "*"*50
    # JSON.parse(post.body)['list'].each do |t|
    #   puts estimated_time(t[1]["word_count"].to_i)
    # end
    # # content = JSON.parse(post.body)['list'].first
    # # puts content[1]["word_count"]
    # #It's returned as a string! So remember to change it to an integer!
    # puts "*"*50
    return JSON.parse(post.body)
  end

  def fetch_unread_articles_from_pocket
    conn = Faraday.new('https://getpocket.com')
    returned_json = conn.post '/v3/get', { 'consumer_key' => ENV['POCKET_CONSUMER_KEY'], 'access_token' => self.access_token, "contentType" => "article", "detailType" => "complete" }, { 'X-Accept' => 'application/json' }
    unread_articles = JSON.parse(returned_json.body)
    pp unread_articles
    return unread_articles
  end

  def find_article_word_count
    word_count_array = []
    complete_oauth['list'].each do |article_object|
      word_count_array << article_object[1]["word_count"]
    end
      return word_count_array
  end

  def find_estimated_article_time
    find_article_word_count.each do |word_count|
      num_word_count = word_count.to_i
    puts estimated_time(num_word_count)
    end
  end

  def estimated_time(word_count)
  	@time = word_count/200.0

  	if @time >= 60
  		@hour = (@time/60).floor
  		@minutes = (@time%60).ceil

  		if @hour == 1
  			return @hour.to_s + " " + "hour " + @minutes.to_s + " " + "minutes"
  		else
  			return @hour.to_s + " " + "hours " + @minutes.to_s + " " + "minutes"
  		end

  	else
  		return @time.to_s + " " + "minutes"
  	end
  end

end
  	# return time.to_s + " " + "minutes"
