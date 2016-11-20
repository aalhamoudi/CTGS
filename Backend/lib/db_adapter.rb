class DBAdapter

	# This class only contains class methods that will interact with the
	# database through the provided model's methods.
	def self.fetch_model(model_type, id)
		return User.find(id) if model_type == :user or model_type == :users
	end
	
	# This method will create and attempt to save the model to the database. Saving
	# the model will be useless. An exeption will be raised if the parameters contain
	# a field that the model does not have. An exception will be raised if the model
	# was not saved.
	def self.create_model(model_type, params)
		model = self.get_class_from_type(model_type).create(params)
		method = JSONResponse.method("get_json_success")
		{"method" => method, "model" => model, "status" => model.status}
	end

	# This method, as implied, is responsible for user authentication. As username
	# and password are passed in the parameters. The system will look up the user and
	# check if the user provided valid credentials. The appropriate status shall be
	# returned accordingly.
	def self.authenticate(model_type, params)
		# Get the data
		login_id = params["login_id"]; password = params["password"]
		password = munch_down password

		# Find the model
		model = self.get_class_from_type(model_type).find_by(:login_id => login_id)
		raise AppError::NoUsernameError.new(Status::Errors::ERROR_USER_INVALID_USERNAME_PASSWORD) if model.nil?

		# Authenticate the model and wrap up
		auth_user = model.authenticate(password)
		raise AppError::AuthenticationError.new(Status::Errors::ERROR_USER_INVALID_USERNAME_PASSWORD) if !auth_user
		status = Status::Success::SUCCESSFUL_USER_AUTHENTICATION
		method = JSONResponse.method("get_json_success")

		# Do not return an instance of the model
		{"method" => method, "status" => status}
	end

	# This method is responsible for updating the model specified by its database
	# id using the specified paramaters. An exeption will be raised if the parameters
	# contain a field that the model does not have.
	def self.update_model(model_type, id, params)
		model = self.get_class_from_type(model_type).find(id)
		method = self.save_model(model, :update, params)
		{"method" => method, "model" => model, "status" => model.status}
	end

	# This method is responsible for simply deleting the record specified by type
	# and id. An exception will be raised should the deleting not be complete
	def self.delete_model(model_type, id)
		model = self.get_class_from_type(model_type).find(id)
		model.destroy
		method = JSONResponse.method("get_json_success")
		{"method" => method, "status" => Status::Success::SUCCESSFUL_USER_DELETE, "model" => model}
	end
	
	private
		# This method returns the calleable class variables specified by the model_type
		def self.get_class_from_type(model_type)
			return User if model_type == :user or model_type == :users
			raise AppError.new("Invalid model type: #{model_type}")
		end

		# This method does the actually saving of the method. Should never be direcly 
		# used outside this class.
		def self.save_model(model, tag, params=nil)
			result = tag == :update ? model.update_attributes(params) : model.save
			result ? JSONResponse.method("get_json_success") : JSONResponse.method("get_json_error_not_saved")
		end

		# This method takes can of decoding the encrypted password. Not implemented yet.
		def self.munch_down(password)
			raise AppError::NotImplementedError.new("Password needs to be munched down.")
			password
		end

end