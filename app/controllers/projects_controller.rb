class ProjectsController < ApplicationController

    before_action :require_same_user, only: [:edit,:update,:destroy]

    def index
        if user_signed_in?
            if current_user.usertype=='Manager'
                @project=current_user.created_projects
            elsif current_user.usertype=='Developer'
                @project=current_user.assigned_projects
            elsif current_user.usertype=='QA'
                @project=current_user.assigned_projects
            end
        else
            flash[:alert]="You need to login to view your Projects"
            redirect_to root_path
        end
    end
    
    def new
        @project=Project.new
        if can? :create,@project    
        else
            flash[:alert]="You are not allowed to create a project"
            redirect_to root_path
        end
    end
    
    def create
        @project=Project.new(project_params)
        @project.creator_id=current_user.id
            if @project.save
                flash[:success]="Project was created Successfully"
                redirect_to projects_path
            else
                render 'new' , status: :unprocessable_entity
            end

    end
    
    def edit
        @project=Project.find(params[:id])
        if can? :edit,@project
        else
            flash[:alert]="You are not allowed to edit the project"
            redirect_to projects_path(@project)
        end
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
        if user_signed_in?
            if can? :show,Project
            @project=Project.find(params[:id])
            end
        else 
            flash[:alert]="Sorry you need to login first"
            redirect_to root_path
        end
    end
    
    def destroy
        if can? :destroy,Project
            @project=Project.find(params[:id]).destroy
            flash[:success]="Project was deleted successfully"
            redirect_to projects_path , status: :see_other
        end
    end
    
    private
    
    def project_params
        params.require(:project).permit(:title,:description,user_ids: [])
    end

    def require_same_user
    
    end
    
    
    end