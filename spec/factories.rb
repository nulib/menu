FactoryGirl.define do

  factory :new_record do
    sequence(:filename) { |n| "#{n}.tiff" }
    job
  end

  factory :job do
    sequence(:job_id) { |n| "#{n}" }
    
    factory :job_with_new_records do
      transient do
        new_records_count 2
      end

      after(:create) do | job, evaluator |
        create_list(:new_record, evaluator.new_records_count, job: job)
      end

    end
  end
end