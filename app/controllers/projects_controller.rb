class ProjectsController < ApplicationController

    def index
        @projects=Project.all
    end
    
    def new
        @project=Project.new
    end
    
    def create
        @project=Project.new(project_params)
        @project.creator_id=current_user.id
            if @project.save
                flash[:success]="Project was created Successfully"
                redirect_to projects_path
            else
                flash[:danger]="Only a manager can create a Project"
                render 'new' , status: :unprocessable_entity
            end
    end
    
    def edit
        @project=Project.find(params[:id])
    end
    
    def update
        @project=Project.find(params[:id])
        if @project.update(project_params)
            flash[:success]="Your Project was updated successfully"
            redirect_to projects_path
        else
            render 'edit' , status: :unprocessable_entity
        end
    end
    
    def show
        @project=Project.find(params[:id])
    end
    
    def destroy
        @project=Project.find(params[:id]).destroy
        flash[:success]="Project was deleted successfully"
        redirect_to projects_path , status: :see_other
    end
    
    private
    
    def project_params
        params.require(:project).permit(:title,:description)
    end
    
    
    end