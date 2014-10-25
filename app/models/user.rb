class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

         has_many :reads

  def request_token
    conn = Faraday.new('https://getpocket.com')
    post = conn.post '/v3/oauth/request', { 'consumer_key' => "POCKET_CONSUMER_KEY", 'redirect_uri' => 'localhost:3000'}, { 'X-Accept' => 'application/json' }
    @code = JSON.parse(post.body)['code']
    return @code
  end

  def oauth
    conn = Faraday.new('https://getpocket.com')
    post = conn.post 'v3/oauth/authorize', { 'consumer_key' => "POCKET_CONSUMER_KEY", 'code' => @code }, { 'X-Accept' => 'application/json' }
    puts post
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
