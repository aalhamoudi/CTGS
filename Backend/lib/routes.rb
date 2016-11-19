class Routes

	# This class is responsible for retrieving all paths from the config file.

	ALL_ROUTES_JSON_PATH = "config/routes.json"
	CONTENTS = []

	def self.all(*tags)
		all_routes = self.config_contents["routes"]
		return all_routes if tags.nil? or tags.empty?
		controller_name = tags[0].to_s
		tags.each do |tag|
			all_routes = all_routes[tag.to_s]
			return "#{controller_name}##{all_routes}" if tag == :method
		end
		all_routes
	end

	private
		def self.config_contents
			# Empty out CONTENTS
			CONTENTS.reject { |e| e }

			# And begin the parsing process
			begin
				to_parse = open ALL_ROUTES_JSON_PATH, "r" do |io| io.read end
			rescue Errno::ENOENT => e
				puts e
			end
			parsed = JSON.parse to_parse
			if parsed
				parsed.each do |c|
					CONTENTS.push c
				end
			end
		end

end