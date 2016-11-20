class User < ActiveRecord::Base

    CONFIG_PATH = "../Middletier/restrictions.json"
    REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    before_save {
        # Check if the login_id and the password are present.
        if (self.login_id.nil? or self.login_id.strip.size == 0) and self.password_is_empty?
            raise AppError.new Status::Errors::ERROR_USER_REGISTRATION_MISSING_CREDENTIALS
        end
        # Make sure the password is there, again.
        if self.new_record? and (self.password.nil? or self.password_is_empty?)
            raise AppError.new Status::Errors::ERROR_USER_REGISTRATION_MISSING_PASSWORD
        end
        # Downcase the login_id and make it is not used.
        self.login_id.downcase!
        if self.class.exists(:login_id, self.login_id, self.id)
            raise AppError.new Status::Errors::ERROR_USER_REGISTRATION_RESERVERED_LOGIN_ID
        end
        # Make sure the login_id is long enough
        if self.login_id.size < self.get_config["login_id"]["min"]
            raise AppError.new Status::Errors::ERROR_USER_REGISTRATION_SHORT_LOGIN_ID
        end
        # Make sure the password is long enough
        if self.new_record? and self.password.size < self.get_config["password"]["min"]
            raise AppError.new Status::Errors::ERROR_USER_REGISTRATION_SHORT_PASSWORD
        end
        # Make sure the password and password_confirmation match.
        if self.password != self.password_confirmation
            raise AppError.new Status::Errors::ERROR_USER_REGISTRATION_UNMATCHING_PASSWORDS
        end
        # Make sure, if provided, the email is valid.
        if !self.email.nil? and self.email.strip.size > 0 and (self.email =~ REGEX).nil?
            raise AppError.new Status::Errors::ERROR_USER_REGISTRATION_INVALID_EMAIL_ADDRESS
        end
        @status = self.new_record? ? Status::Success::SUCCESSFUL_USER_CREATION : Status::Success::SUCCESSFUL_USER_UPDATE
    }

    before_destroy {
        # Make sure there is at least one user in the database.
        raise AppError.new Status::Errors::ERROR_USER_ONLY_USER if User.all.size <= 1
    }

    def password_is_empty?
        self.password.size == 0
    end

    def is_privileged?
        false
    end

    def status
        @status
    end

    def to_json
        self.to_h.to_json
    end

    def to_h
        data = {}
        # Dynamically retrieve the allowed fields. Important for inheritance.
        # Also, make sure NO arguments are need... this will cause an exception... Not
        # good at all.
        allowed_attributes("is_privileged?", "get_config").each do |af|
            af = af.to_s
            data[af] = self.method(af).call
        end
        data
    end

    def code=(code)
        @code = code
    end

    def code
        @code
    end

    def get_config
        self.class.get_config
    end

    def self.all_privileged
        User.all.reject { |e| !e.is_privileged? }
    end

    def self.exists(what, value, id=nil)
        user = User.find_by(what => value)
        id.nil? ? !user.nil? : !user.nil? and user.id != id
    end

    def self.get_config
        JSONConfig.get(CONFIG_PATH)["users"]
    end

	has_secure_password

    private
        def disallowed_attributes
            ["password", "password_confirmation", "password_digest"]
        end

        def allowed_attributes(*extra_attributes)
            # Removed all disallowed attributes
            r = all_attributes.reject { |a| disallowed_attributes.include? a }

            # Make sure there are any duplicates
            extra_attributes.reject! { |d| r.include? d }

            # Concatenate both arrays
            r + extra_attributes
        end

        def all_attributes
            self.attributes.keys
        end
end
