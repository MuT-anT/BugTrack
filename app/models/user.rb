class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :name, presence: true

  has_many :created_projects,class_name: "Project", foreign_key: "creator_id"

  has_many :created_bugs, class_name: "Bug",foreign_key: "creator_id"
  has_many :solved_bugs, class_name: "Bug",foreign_key: "solver_id"

  has_many :user_projects
  has_many :projects , through: :user_projects

  enum usertype: {
    Manager: 0,
    Developer: 1,
    QA: 2
  }

end
