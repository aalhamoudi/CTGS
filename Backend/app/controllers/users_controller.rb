class UsersController < ApplicationController

	parser = Parsing::ParamsParser

	# The create controller. This method is responsible for creating a user given
	# certain parameters. Here are the params expected by the client:
	# [login_id, password_digest, email]
    def create
        tags = params[:tags]
        tags = parser.parse(tags)
        model = DBAdapter.save_model(:user, tags)
        method_to_call = model.saved? ? JSONResponse.method("get_json_success") : JSONResponse.method("get_json_error_not_saved")
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
