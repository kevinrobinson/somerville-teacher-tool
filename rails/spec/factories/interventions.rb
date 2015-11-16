FactoryGirl.define do
  factory :intervention do
    start_date Date.new(2014, 9, 9)
    number_of_hours 10
    factory :atp_intervention do
      association :intervention_type, name: "After-School Tutoring (ATP)"
      factory :more_recent_atp_intervention do
        start_date Date.new(2015, 9, 9)
        number_of_hours 11
      end
    end
    factory :non_atp_intervention do
      association :intervention_type, name: "Extra Dance "
    end
  end
end
