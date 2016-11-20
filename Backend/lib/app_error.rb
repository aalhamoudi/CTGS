class AppError < StandardError

    # Contrustor
    def initialize(message, code=500)
        if message.instance_of? Hash
            @code = message["id"]
            @message = message["message"]
        else
            @code = code
            @message = message
        end
    end

    # Get the code
    def code
        @code
    end

    # Set the code
    def code=(code)
        @code = code
    end

    # Get the message
    def message
        @message
    end

    # Set the message
    def message=(message)
        @message = message
    end

    class UnusableClassOrMethodError < AppError
        # An instance of this class will be raised when a feature should, is,
        # can or will not be used. All methods/classes deemed deprecated will
        # raise an instance of this class.
    end

    class NotImplementedError < UnusableClassOrMethodError
        # An instance of this class is raised if a specific feature or method
        # is not implemented yet, and therefore cannot be used.

        # Override the message
        def message
            @message = "None." if @message.nil? or @message.strip.size == 0
            "This function was not implemented yet. Reason: " << @message
        end
    end

    class AuthenticationError < AppError
        # An instance of this class will be raised if there was an issue with
        # authenticating the user. Main reasons include, but are not limited to:
        #  - invalid password (encoding, etc.)
        #  - wrong password
        #  - etc.
    end

    class NoUsernameError < AuthenticationError
        # An instance of the class will be raised only when a specified user by
        # its login_in is not found on authentication.
    end

end