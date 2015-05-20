class Job < ActiveRecord::Base
  has_many :new_records,-> { order "filename asc" }

  validates :job_id, uniqueness: true
end
