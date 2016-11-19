class JSONResponse

	def get_json_sucess(model)
		model.to_json
	end

	def get_json_error_not_saved(model)
		{
			"code" => 1,
			"messages" => model.errors.full_messages
		}.to_json
	end

    def self.json(code=0, message)
        json = {
            code: code,
            message: message
        }
    end

    def self.default
        self.json(0, "**No message**")
    end

end