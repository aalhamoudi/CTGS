routes = Routes.method(:all)
#Routes.add_api

Rails.application.routes.draw do

    # Routes managed by ApplicationController
    root Routes.all(:application, :root, :method)

    # Routes managed by UserController
    get Routes.all(:users, :get, :path) => Routes.all(:users, :get, :method)
    #get Routes.all(:users, :create, :path) => Routes.all(:users, :create, :method)
    get "/users/new/:tags" => Routes.all(:users, :create, :method)

end
