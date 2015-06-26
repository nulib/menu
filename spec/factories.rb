FactoryGirl.define do

  factory :new_record do
    sequence(:filename) { |n| "#{n}.tiff" }
    job
  end

  factory :existing_record do
    pid  "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"
    xml  "<vra:vra xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:fn='http://www.w3.org/2005/xpath-functions' xmlns:marc='http://www.loc.gov/MARC21/slim' xmlns:mods='http://www.loc.gov/mods/v3' xmlns:vra='http://www.vraweb.org/vracore4.htm' xsi:schemaLocation='http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd' prefix='/vra:vra/vra:work:'>
      <vra:image id='inu-dil-2559730_w' refid='inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60'>
        <!--Agents-->
        <vra:agentSet>
            <vra:display>United States. War Production Board ; U.S. G.P.O.</vra:display>
            <vra:agent>
                <vra:name type='corporate' vocab='lcnaf'>Bon Bon</vra:name>
                <vra:attribution/>
            </vra:agent>
            <vra:agent>
                <vra:name type='corporate' vocab='lcnaf'>U.S. G.P.O.</vra:name>
            </vra:agent>
        </vra:agentSet>
        <vra:culturalContextSet>
            <vra:display/>
            <vra:culturalContext/>
        </vra:culturalContextSet>
        <!--Dates-->
        <vra:dateSet>
            <vra:display>1942</vra:display>
            <vra:date type='creation'>
                <vra:earliestDate>1942</vra:earliestDate>
            </vra:date>
        </vra:dateSet>
        <!-- Titles -->
        <vra:titleSet>
            <vra:display>'Every man, woman and child is a partner'</vra:display>
            <vra:title pref='true'>'Every man, woman and child is a partner'</vra:title>
        </vra:titleSet>
        <vra:worktypeSet>
            <vra:display/>
            <vra:worktype/>
        </vra:worktypeSet>
      </vra:image>
      </vra:vra>"
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