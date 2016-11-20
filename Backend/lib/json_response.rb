class JSONResponse

    # This class is responsible for returning formatted JSON (to a controller,
    # an object, etc.). The methods are self-explainatory.

    DEFAULT_CODE = Status::Success::SUCCESSFUL_OPERATION["id"]
    DEFAULT_MESSAGE = Status::Success::SUCCESSFUL_OPERATION["message"]

	def self.get_json_success(model, code: DEFAULT_CODE, message: DEFAULT_MESSAGE)
        {
            "code" => code,
            "message" => message,
            "data" => (model.nil? ? nil : model.to_h)
        }.to_json
	end

	def self.get_json_error_not_saved(model)
		{
			"code" => 1,
			"messages" => model.errors.full_messages
		}.to_json
	end

    def self.json(code=0, message=nil, body: nil)
        json = {
            code: code,
            message: message,
            data: body
        }
    end

    # Return default JSON. Used only for testing.
    def self.default
        raise AppError::UnusableClassOrMethodError.new("Unsupported feature.") if Routes.testing
        self.json(0, "**No message**")
    end

end