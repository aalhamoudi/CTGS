class Status
    # This class is responsible for managing status codes.

    class Success
        # This class class is reponsible for managing successful status
        # codes.

        SUCCESS_PATH = "../Middletier/success.json"

        # Returns the JSON at the default path.
        def self.get
            JSONConfig.get(SUCCESS_PATH) 
        end

        def self.general
            self.get["general"]
        end

        def self.users
            self.get["users"]
        end

        # General operation
        SUCCESSFUL_OPERATION = self.general[0]

        # User related operations
        SUCCESSFUL_USER_CREATION = self.users[0]
        SUCCESSFUL_USER_UPDATE = self.users[1]
        SUCCESSFUL_USER_DELETE = self.users[2]
        SUCCESSFUL_USER_AUTHENTICATION = self.users[3]
    end

    class Errors
        # This class class is reponsible for managing error status codes.
        ERRORS_PATH = "../Middletier/errors.json"
        
        # Returns the JSON at the default path.
        def self.get
            JSONConfig.get(ERRORS_PATH)
        end

        def self.general
            self.get["general"]
        end

        def self.users
            self.get["users"]
        end

        def self.registration
            self.get["registration"]
        end

        # General errors
        ERROR_NON_UNIQUE_DB_ID = self.general[0]

        # User related operations
        ERROR_USER_NOT_FOUND = self.users[0]
        ERROR_USER_EMPTY_PASSWORD = self.users[1]
        ERROR_USER_INVALID_PASSWORD = self.users[2]
        ERROR_USER_ONLY_USER = self.users[3]
        ERROR_USER_INVALID_USERNAME_PASSWORD = self.users[4]

        # User registration related operations
        ERROR_USER_REGISTRATION_MISSING_CREDENTIALS = self.registration[0]
        ERROR_USER_REGISTRATION_RESERVERED_LOGIN_ID = self.registration[1]
        ERROR_USER_REGISTRATION_INVALID_CHARACTERS = self.registration[2]
        ERROR_USER_REGISTRATION_SHORT_LOGIN_ID = self.registration[3]
        ERROR_USER_REGISTRATION_MISSING_PASSWORD = self.registration[4]
        ERROR_USER_REGISTRATION_SHORT_PASSWORD = self.registration[5]
        ERROR_USER_REGISTRATION_UNMATCHING_PASSWORDS = self.registration[6]
        ERROR_USER_REGISTRATION_INVALID_EMAIL_ADDRESS = self.registration[7]

        # Returns a JSON formated error message for exception. This method is
        # specilized for instances of AppError and should not be confused with
        # JSONResponse's JSON methods. Other exceptions can also be passed in.
        def self.exception_json(exception, code=500, *additional_messages)
            message = exception
            if exception.instance_of? AppError
                code = exception.code
            end
            message = exception.message if exception.class < Exception
            messages = [message]
            messages = messages + additional_messages if additional_messages.size > 0
            {
                "code" => code,
                "messages" => messages,
                "exception_type" => exception.class.to_s
            }
        end
        
    end

end