require "feedzirra"

def rssfeed(feed_url)
  feed = Feedzirra::Feed.fetch_and_parse(feed_url).entries
end