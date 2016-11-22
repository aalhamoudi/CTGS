class Routes
    p "******** Routes!!!"

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

	def self.requires_admin(controller, action)
		self.required(controller, action, :as_admin, :authentication)
	end

	def self.requires_authentication(controller, action)
		self.required(controller, action, :authentication)
	end

	# Checks if the controller and the action require any of the specified
	# tags (ie: :authentication, :as_admin, ...)
	def self.required(controller, action, *tags)
		raise AppError.new("Could not check anything: no tags specified.") if tags.empty?
		# Check the most important tags first. Return false if one of the tags is not
		# satisfied.
		if tags.include? :as_admin
			result = self._requires(controller, action, :as_admin)
			return false if !result
		end
		if tags.include? :authentication
			return self._requires(controller, action, :authentication)
		end
		false
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

		def self._requires(controller, action, tag)
			# Check if the controller requires the tag
			result = self.all(controller, tag)
			return true if result == true # necessary : we want the "true" value, nothing else

			# Otherwise, check if the action needs the tag
			return self.all(controller, action, tag) == true
		end

end