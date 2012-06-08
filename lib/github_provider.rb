class GithubProvider < RssProvider

	def to_pim atom_item
		type = (atom_item.entry_id.match /\:(\w+)\//)[1].downcase.gsub!(/event/,"")
		Pim.new(
			pid: atom_item.entry_id,
			created_at: atom_item.published,
			message: atom_item.title,
			link: atom_item.url,
			pim_type: type,
			provider: source.provider,
			source: source
		)
	end

end