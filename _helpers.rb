# require "feedzirra"

# TODO: Change to feedburner
FEED_URL = "http://philkates.com/atom.xml"

# def rssfeed(feed_url)
#   feed = Feedzirra::Feed.fetch_and_parse(feed_url).entries
# end

module Helpers
  def post_arrow(post, direction)
    "<a href='#{h(post.url)}'>#{direction}</a>"
  end
end
