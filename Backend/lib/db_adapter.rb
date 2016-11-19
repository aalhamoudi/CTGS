class DBAdapter

	# This class only contains class methods that will interact with the
	# database through the provided model's methods.

	def self.fetch_model(model_type, id)
		return User.find(id) if model_type == :user or model_type == :users
	end

	def self.save_model(model)
		model.save ? JSONResponse.method("get_json_success") : JSONResponse.method("get_json_error_not_saved")
	end
	
	def self.create_model(model_type, params)
		p "PARAMS ARE #{params}"
		model = self.get_class_from_type(model_type).create(params)
		method = !model.id.nil? ? JSONResponse.method("get_json_success") : JSONResponse.method("get_json_error_not_saved")
		[method, model]
	end

	def self.update_model(model_type, id, params)
		model = self.get_class_from_type(model_type).find(id)
		model.update_attributes(params)
		[self.save_model(model), model]
	end

	def self.delete_model(id)
		
	end
	
	def self.get_class_from_type(model_type)
		return User if model_type == :user or model_type == :users
		raise Exception.new("Invalid model type: #{model_type}")
	end

end