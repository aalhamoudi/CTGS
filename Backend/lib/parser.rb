class JSONParser

	# This is a class method that simply takes a object then transforms
	# it into a regular json.

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

class ParamParams

	def parse(tags_string)
		
	end

end