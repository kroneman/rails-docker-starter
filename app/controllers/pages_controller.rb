class PagesController < ApplicationController
    def index
        @my_prop = "Some Random Property"
        @another_prop = "Yay I can debug"
        content_type = request.content_type

        respond_as_json
    end

    private

    def respond_as_json
        if request.content_type == 'application/json'
            render :json => {
                :status => :ok,
                :message => "Success!",
                :html => "<b>Congrats</b>"
            }
        end
    end
end