module ApplicationHelper

    # This method will return an instance of the current user. It is here
    # because it does not concern only users; it is an application-wide
    # imporant variable.
    def current_user
        User.first
    end

    def logged_in?
        !current_user.nil?
    end

end
