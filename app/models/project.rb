class Project<ApplicationRecord
    validates :title,presence: true
    validates :description, presence: true


    has_many :user_projects, dependent: :destroy
    has_many :users , through: :user_projects
    belongs_to :Creator, class_name: "User", foreign_key: "creator_id"

    has_many :bugs ,  dependent: :destroy

end