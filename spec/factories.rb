FactoryGirl.define do

  factory :image do
    sequence(:filename) { |n| "#{n}.tiff"}
    job
  end

  factory :job do
    sequence(:job_id) { |n| "#{n}"}

    factory :job_with_images do
      transient do
        images_count 2
      end

      after(:create) do | job, evaluator |
        create_list(:image, evaluator.images_count, job: job)
      end

    end
  end
end