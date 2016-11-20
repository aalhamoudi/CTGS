class Parsing

    # This class contains Parsing related classes.

    class JSONParser
        # This class is similar to json_response.rb's 'JSONResponse'.

        # This is a class method that simply takes a object then transforms
        # it into a regular json.
        def self.json(code=0, message)
            raise AppError::UnusableClassOrMethodError.new("Unsupported feature.")
            json = {
                code: code,
                message: message
            }
        end

        # Return default JSON. Used only for testing.
        def self.default
            raise AppError::UnusableClassOrMethodError.new("Unsupported feature.")
            self.json(0, "**No message**")
        end

    end

    class ParamsParser
        # This class is reponsible for parsing parameters of all sorts.

        DEFAULT_OPTIONS = {
            "separators" => {
                "main" => "&",
                "others" => ["%", "/"]
            },
            "assignment" => {
                "main" => "=",
                "others" => [":", ".", "*"]
            }
        }

        # This method takes in tags that were passed onto the URL, as transforms
        # that string into a useable hash.
        # Here is an example of a tag that can be passed in, and then how its
        # hash representation should look like.
        # tags_string : "username=my username&title=new title"
        # result: {"username" => "my username", "title" => "new title"}
        def self.parse(tags_string, options: nil)
            return {} if tags_string.nil? or tags_string.strip.size == 0

            # Check how the data should be parsed
            separator = options.nil? ? DEFAULT_OPTIONS["separators"]["main"] : options["separators"]["main"]
            assignment = options.nil? ? DEFAULT_OPTIONS["assignment"]["main"] : options["assignment"]["main"]

            # Assign other separators if needed
            found = false
            if !options.nil? and separator.nil?
                DEFAULT_OPTIONS["separators"]["others"].each do |s|
                    separator = s
                    found = tags_string.include? separator
                    break if found
                end
                raise AppError.new "No valid separator operator was found" if !found
            end

            # Assign other assignment operators if needed
            found = false
            if !options.nil? and assignment.nil?
                DEFAULT_OPTIONS["assignment"]["others"].each do |a|
                    assignment = a
                    found = tags_string.include? assignment
                    break if found
                end
                raise AppError.new "No valid assignment operator was found" if !found
            end

            # Initialize the hash to return
            result = {}

            # Parse the bad boy
            # Get the sub arguments
            sub_arguments = tags_string.split(separator)
            # Iterate over the arguments
            sub_arguments.each do |sub_arg|
                sub_arg = sub_arg.strip
                p "#{sub_arg}: #{sub_arg.class}"
                sub_arg = sub_arg.split assignment
                raise AppError.new "Exactly 2 assignment operators (\"#{assignment}\") are needed." if sub_arg.size != 2
                key = sub_arg[0]
                value = sub_arg[1]
                value = nil if value == "nil" or value == "null" or value == "None"
                result[key] = value
            end
            result
        end

    end

end