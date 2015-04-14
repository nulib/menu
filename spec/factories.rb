
  def yay_mom thing
    byebug
    names = []
    Dir.foreach("lib/assets/dropbox") do |x| 

      if Dir.exist?(x.to_s)
        puts "we exist!"
        puts x.to_s
        names << x.to_s
      end
    end
    puts "names are - #{names}"
    "#{thing}"
  end


FactoryGirl.define do

  factory :image do
    sequence(:filename) { |n| "#{n}.tiff"}
    job
  end

  factory :job do
    sequence(:job_id) { |n| yay_mom(n) }
    
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