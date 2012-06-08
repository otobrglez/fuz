# By Oto Brglez - <oto.brglez@opalab.com>
require "feedzirra"

class RssProvider

	attr_accessor :source


	def initialize source
		@source = source
	end

	def to_pim rss_item
		# return rss_item 
		Pim.new(
			pid: rss_item.entry_id,
			caption: rss_item.title,
			message: rss_item.summary,
			created_at: rss_item.published,
			link: rss_item.url
		)
	end

	def feed options={}
		feed = Feedzirra::Feed.fetch_and_parse source.options["url"]
		return feed.entries.map!{|entry| to_pim(entry)} unless feed.entries.empty?
		[]
	end
end