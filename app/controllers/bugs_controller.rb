class BugsController < ApplicationController
    before_action :set_bug, only: [:edit,:update,:show]
    before_action :authenticate_user!, only: [:new,:show,:edit,:require_same_user]
    #before_action :require_same_user, only: [:edit,:update,:destroy,:show]

    def new
        @bug=Bug.new()
        @project=Project.find_by(id: params[:project_id])
        @developers=@project.users.developer
        @bug_type=Bug.find_by(bug_type: params[:bug_type])
        if can? :create,Bug
        else
            flash[:alert]="You cannot create a Bug"
            redirect_to root_path
        end
    end

    def create
        @bug=Bug.new(bug_params)
        @bug.creator_id=current_user.id
        @project=Project.find_by(id: params[:project_id])
        @bug.project_id=@project.id
        @developers=@project.users.developer
        if @bug.save
            flash[:success]="Bug was created successfully"
            redirect_to project_path(@project)
        else 
            render 'new', status: :unprocessable_entity
        end
    end

    def show
        #if can? :show, @bug
        unless  can? :show, @bug
            flash[:danger]="You cannot view other QA's created bugs"
            redirect_to user_path(current_user)
        end
    end

    def edit
        if can? :edit, @bug
            @bug=Bug.find(params[:id])
            @project=Project.find_by(id: params[:project_id])
            @developers=@project.users.developer
            @bug.project_id=@project.id
            if can? :update,Bug
                @bug=Bug.find(params[:id])
            else
                flash[:alert]="You cannot update this bug"
                redirect_to project_bug_path(@bug)
            end
        else
            flash[:danger] = "You cannot edit other QA's bugs"
            redirect_to user_path(current_user)
        end
    end

    def update
        @project = Project.find_by(id: params[:project_id])
        if @bug.update(bug_params)
            flash[:success]="Bug was updated successfully"
            redirect_to project_bug_path(@bug)
        else
            render 'edit' , status: :unprocessable_entity
        end
    end

    def destroy
        if can? :destroy,@bug
            @bug.destroy
            flash[:success]="Bug was deleted successfully"
            redirect_to user_path, status: :see_other
        end
    end

    private

    def bug_params
        params.require(:bug).permit(:title, :description, :deadline, :bug_type, :bug_status,:image,:solver_id,:project_id)
    end

    def set_bug
        @bug=Bug.find(params[:id])
    end

    # def require_same_user
    #         if current_user.usertype=='qa' and current_user.id != @bug.creator_id
    #             flash[:danger]="You are not authorized to do this"
    #             redirect_to root_path
    #         end
    #         if current_user.usertype=='developer' and current_user.id != @bug.solver_id
    #             flash[:danger]="You are not authorized to do this"
    #             redirect_to root_path
    #         end
    #         if current_user.usertype=='manager' and current_user.id != @bug.creator_id
    #             flash[:danger]="You are not authrozied to do this"
    #             redirect_to root_path
    #         end
    # end

end