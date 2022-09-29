class BugsController < ApplicationController

    def index

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
        @developer=User.where(usertype: "Developer")
        @bug.solver_id=@developer.id
        @project=Project.find_by(params[:project_id])
        @bug.project_id=@project.id
        @titles=Project.find(@bug.project_id).bugs
            if @bug.save
                flash[:success]="Bug was created successfully"
                redirect_to project_path(@project)
            else 
                render 'new', status: :unprocessable_entity
            end
    end

    def show
        @bug=Bug.find(params[:id])
    end

    def edit
        @bug=Bug.find(params[:id])
        if can? :update,Bug
        else
            flash[:alert]="You cannot update this bug"
            redirect_to bug_path(@bug)
        end
    end

    def update
        @bug=Bug.find(params[:id])
        if @bug.update(bug_params)
            flash[:success]="Recipe was updates successfully"
            redirect_to bug_path(@bug)
        else
            render 'edit' , status: :unprocessable_entity
        end
    end

    def destroy

    end

    private

    def bug_params
        params.require(:bug).permit(:title,:description,:deadline,:bug_type,:bug_status,:image)
    end
end