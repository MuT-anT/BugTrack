class Bug< ApplicationRecord
    validates :title,presence: true
    validates :bug_status, presence: true
    validates :bug_type, presence: true

    belongs_to :project

    belongs_to :Bug_creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :Solver, class_name: "User", foreign_key: "solver_id"


    mount_uploader :image, FileUploader

    enum bug_type: {
        Feature: 0,
        Bug: 1
    }

end