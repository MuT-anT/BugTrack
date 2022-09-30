class BugsController < ApplicationController
    def index

    end

    def new
        @bug=Bug.new()
        @project=Project.find_by(id: params[:project_id])
        @developers=@project.users.Developer
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
        @developers=@project.users.Developer
        if @bug.save
            flash[:success]="Bug was created successfully"
            redirect_to project_path(@project)
        else 
            render 'new', status: :unprocessable_entity
        end
    end

    def show
        if user_signed_in?
            @bug=Bug.find(params[:id])
        else
            flash[:alert]="You are not loggged in"
            redirect_to root_path
        end
    end

    def edit
        if user_signed_in?
            @bug=Bug.find(params[:id])
            @project=Project.find_by(id: params[:project_id])
            @developers=@project.users.Developer
            @bug.project_id=@project.id
            if can? :update,Bug
            @bug=Bug.find(params[:id])
            else
                flash[:alert]="You cannot update this bug"
                redirect_to project_bug_path(@bug)
            end
        else
            flash[:alert]="Sorry you are not logged in"
            redirect_to root_path
        end
    end

    def update
        @project = Project.find_by(id: params[:project_id])
        @bug=Bug.find(params[:id])

        if @bug.update(bug_params)
            flash[:success]="Bug was updated successfully"
            redirect_to project_bug_path(@bug)
        else
            render 'edit' , status: :unprocessable_entity
        end
    end

    def destroy
        if can? :destroy,Bug
            @pbug=Bug.find(params[:id]).destroy
            flash[:success]="Bug was deleted successfully"
            redirect_to projects_path , status: :see_other
        end
    end

    private

    def bug_params
        params.require(:bug).permit(:title,:description,:deadline,:bug_type,:bug_status,:image,:solver_id,:project_id)
    end
end