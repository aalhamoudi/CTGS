class Routes

	# This class is responsible for retrieving all paths from the config file.

	#ALL_ROUTES_JSON_PATH = "config/routes.json"
	ALL_ROUTES_JSON_PATH = "../Middletier/schema.json"
	CONTENTS = []

	def self.all(*tags)
		all_routes = self._config_contents["routes"]
		return all_routes if tags.nil? or tags.empty?
		controller_name = tags[0].to_s
		tags.each do |tag|
			#next if self.is_testing and all_routes["only_testing"]
			all_routes = all_routes[tag.to_s]
			return "#{controller_name}##{all_routes}" if tag == :method
			return "#{self._api}#{all_routes}" if tag == :path
		end
		all_routes
	end
	
	# Marker methods
	def self.add_api
		@do_it = true
	end

	def self.set_testing
		@testing = true
	end

	def self.is_testing
		@testing
	end

	private
		def self._config_contents
			# Empty out CONTENTS
			JSONConfig.get(ALL_ROUTES_JSON_PATH)
			#CONTENTS
		end
	
		def self._api
			return "/api" if @do_it	
		end

end