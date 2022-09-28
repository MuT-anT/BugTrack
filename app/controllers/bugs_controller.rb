class BugsController < ApplicationController

    def index
        if @current_user.usertype=='Manager'
            @bugs=current_user.bugs
        elsif @current_user.usertype=='Developer'
            @bugs=current_user.solved_bugs
        elsif @current_user.usertype=='QA'
            @bugs=current_user.created_bugs
        end
    end

    def new
        @bug=Bug.new
        @project = Project.find_by(params[:project_id])
        if can? :create,Bug
        else
            flash[:alert]="You cannot create a Bug"
            redirect_to root_path
        end
    end

    def create
        @bug=Bug.new(bug_params)
        @bug.creator_id=current_user.id
        @bug.solver_id=User.find(params[:id:10])
        @project=Project.find_by(params[:project_id])
        @bug.project_id=@project.id
        @titles=Project.find(@bug.project_id).bugs
            if @bug.save
                flash[:success]="Bug was created successfully"
                redirect_to projects_path(@project)
            else 
                render 'new', status: :unprocessable_entity
            end
    end

    def show
        @bugs=Bug.find(params[:id])
    end

    def edit

    end

    def update

    end

    def destroy

    end

    private

    def bug_params
        params.require(:bug).permit(:title,:description,:deadline,:bug_type,:bug_status,:image)
    end
end