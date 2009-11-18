# FEED_URL = "http://philkates.com/atom.xml"
FEED_URL = "http://feeds.feedburner.com/philkates"

module Helpers
  def post_arrow(post, direction)
    "<a href='#{h(post.url)}'>#{direction}</a>"
  end
  def page_link(post)
    h(post.url)
  end
end
