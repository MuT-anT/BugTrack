class UsersController<ApplicationController
    before_action :set_user, only: [:show]
    before_action :authenticate_user!
    #before_action :require_same_user, only: [:show]

    def show
        if can? :show, @user
            @user_projects=@user.created_projects
            @user_solbugs=@user.solved_bugs
            @user_createdbugs=@user.created_bugs
        else
            flash[:danger] = "You cannot view other user's profile"
            redirect_to user_path(current_user)
        end
    end

    private

    def set_user
        @user=User.find(params[:id])
    end

    # def require_same_user
    #     if current_user != @user
    #         flash[:danger]="You are not signed in"
    #         redirect_to root_path
    #     end
    # end

end