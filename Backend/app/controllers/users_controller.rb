class UsersController < ApplicationController

	parser = Parsing::ParamsParser

	# The create controller. This method is responsible for creating a user given
	# certain parameters. Here are the params expected by the client:
	# [login_id, password_digest, email]
    def create
        tags = params[:tags]
        tags = Parsing::ParamsParser.parse(tags)
        method_to_call = DBAdapter.create_model(:user, tags)
        model = method_to_call[1]
        method_to_call = method_to_call[0]
        render :json => method_to_call.call(model)
    end

    def get
        id = params[:id]
        model = DBAdapter.fetch_model(:user, id)
        render :json => model.to_json
    end

    def update
        id = params[:id]
    end

    def delete
        id = params[:id]
    end

end
