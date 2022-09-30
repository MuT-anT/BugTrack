class UsersController<ApplicationController

    def show
        if user_signed_in?
        @user=User.find(params[:id])
        @user_projects=@user.created_projects
        @user_solbugs=@user.solved_bugs
        @user_createdbugs=@user.created_bugs
        else
            redirect_to root_path
        end
    end
end