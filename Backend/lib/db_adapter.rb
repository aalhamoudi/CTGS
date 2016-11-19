class DBAdapter

	# This class only contains class methods that will interact with the
	# database through the provided model's methods.

	def self.fetch_model(model_type, id)
		return User.find(id) if model_type == :user or model_type == :users
	end

	def self.save_model(model_type, params)

	end

	def self.update_model(model, params, required)

	end

	def self.delete_model(id)

	end

end