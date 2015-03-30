class Job < ActiveRecord::Base
  has_many :images,-> { order "filename asc" }

  validates :job_id, uniqueness: true
end
