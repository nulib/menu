class Job < ActiveRecord::Base
  has_many :images

  validates :job_id, uniqueness: true
end
