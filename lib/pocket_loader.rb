module PocketLoader
  def self.add_article(article)
    read = Read.new
    read.title = article[1]['resolved_title']
    read.excerpt = article[1]['excerpt']
    read.url = article[1]['resolved_url']
    read.save
  end
end