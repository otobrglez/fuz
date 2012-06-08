class YoutubeProvider < RssProvider

	def to_pim rss_item
		video_id = rss_item.entry_id.split("/").last
		Pim.new(
			pid: video_id,
			message: rss_item.title,
			created_at: rss_item.published,
			link: rss_item.url,
			pim_type: "video",
			provider: source.provider,
			source: source,
			picture: "http://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
		)
	end

end