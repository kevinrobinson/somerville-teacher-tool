FactoryGirl.define do
  sequence(:local_id) { |n| "#{n}000" }
end

FactoryGirl.define do

  factory :student do
    local_id
    association :homeroom
    factory :student_who_registered_in_2013_2014 do
      registration_date Date.new(2013, 8, 1)
    end
    factory :second_grade_student do
      grade "2"
    end
    factory :pre_k_student do
      grade "PK"
    end
    factory :student_we_want_to_update do       # Test importing data from X2, STAR
      local_id "10"                             # State ID matches fixture
      home_language "English"
    end
    factory :student_with_homeroom do
      association :homeroom, name: "601"
    end
    factory :student_with_full_name do
      first_name Faker::Name.first_name
      last_name Faker::Name.last_name
    end
    factory :student_named_juan do
      first_name "Juan"
    end
    factory :sped_student do
      program_assigned "Sp Ed"
      sped_placement "Full Inclusion"
    end
    factory :limited_english_student do
      limited_english_proficiency "Limited"
    end

    factory :student_with_registration_date do
      registration_date Date.new(2015, 1, 1)
      factory :student_with_mcas_assessment do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:mcas_assessment)
        end
      end
      factory :student_with_mcas_math_assessment do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:mcas_math_assessment)
        end
      end
      factory :student_with_mcas_ela_assessment do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:mcas_ela_assessment)
        end
      end
      factory :student_with_mcas_math_warning_assessment do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:mcas_math_warning_assessment)
        end
      end
      factory :student_with_mcas_math_advanced_and_star_math_warning_assessments do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:mcas_math_advanced_assessment)
          student.student_assessments << FactoryGirl.create(:star_math_warning_assessment)
        end
      end
      factory :student_with_star_math_assessment do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:star_math_assessment)
        end
      end
      factory :student_with_star_math_and_star_reading_same_day do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:star_math_assessment)
          student.student_assessments << FactoryGirl.create(:star_reading_assessment)
        end
      end
      factory :student_with_star_math_student_assessments_different_days do
        after(:create) do |student|
          sooner = FactoryGirl.create(:star_math_assessment)
          later = FactoryGirl.create(:star_math_assessment_on_different_day)
          student.student_assessments << [sooner, later]
        end
      end
      factory :student_with_star_assessment_between_30_85 do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:star_assessment_between_30_85)
        end
      end
      factory :student_with_dibels do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:dibels_with_performance_level)
        end
      end
      factory :student_with_access do
        after(:create) do |student|
          student.student_assessments << FactoryGirl.create(:access)
        end
      end
      # Test interventions
      factory :student_with_one_atp_intervention do
        after(:create) do |student|
          FactoryGirl.create(:atp_intervention, student: student)
        end
      end
      factory :student_with_one_non_atp_intervention do
        after(:create) do |student|
          FactoryGirl.create(:non_atp_intervention, student: student)
        end
      end
      factory :student_with_multiple_atp_interventions do
        after(:create) do |student|
          FactoryGirl.create(:atp_intervention, student: student)
          FactoryGirl.create(:more_recent_atp_intervention, student: student)
        end
      end
    end
    # Test STAR Instructional Reading Level
    factory :student_behind_in_reading do
      grade "5"
      after(:create) do |student|
        student.student_assessments << FactoryGirl.create(:star_assessment_with_irl_below_4)
      end
    end
    factory :student_ahead_in_reading do
      grade "5"
      after(:create) do |student|
        student.student_assessments << FactoryGirl.create(:star_assessment_with_irl_above_5)
      end
    end
    # Test event sorting
    factory :student_with_attendance_event do
      registration_date Date.new(2014, 8, 1)
      after(:create) do |student|
        student.attendance_events << FactoryGirl.create(:absence)
      end
    end
    factory :student_with_discipline_incident do
      registration_date Date.new(2014, 8, 1)
      after(:create) do |student|
        student.discipline_incidents << FactoryGirl.create(:discipline_incident)
      end
    end
  end
end
