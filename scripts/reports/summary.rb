# This file has a few scripts for hacking on what distributions of student risk levels, assessments, and interventions.
# It's intended to be run interactively in a Rails console.
# You can paste the whole file in, and then run `main()` to see summary information.


def tardies(student_id, options = {})
  cutoff = options[:cutoff] || 90.days
  cutoff_date = Time.new - cutoff
  attendance_events = AttendanceEvent.where(:student_id => student_id)
  recent_events = attendance_events.select {|attendance_event| attendance_event.event_date > cutoff_date }
  recent_events.select(&:tardies)
end

# [{3=>[{"W"=>7}, {"B"=>3}, {"H"=>4}, {"A"=>3}]}, {2=>[{"B"=>3}, {"H"=>2}, {"W"=>1}]}, {0=>[{"H"=>5}, {"A"=>1}, {"W"=>1}]}]
def risk_level_by_race
  Student.all.group_by {|s| s.student_risk_level.level }.map {|k, vs| { k => vs.group_by(&:race).map {|r, ss| { r => ss.size } } } }
end
  
# [{:race=>"W", :levels=>[{:level=>3, :count=>7}, {:level=>0, :count=>1}, {:level=>2, :count=>1}]}, {:race=>"B", :levels=>[{:level=>2, :count=>3}, {:level=>3, :count=>3}]}, {:race=>"H", :levels=>[{:level=>2, :count=>2}, {:level=>0, :count=>5}, {:level=>3, :count=>4}]}, {:race=>"A", :levels=>[{:level=>0, :count=>1}, {:level=>3, :count=>3}]}]
def per_race_risk_levels
  Student.all.group_by(&:race).map {|k, vs| { race: k, levels: vs.group_by{|s| s.student_risk_level.level }.map {|level, ss| { level: level, count: ss.count } } } }
end

# [{:intervention_count=>1, :student_count=>30}]
def intervention_count
  Student.all.group_by {|s| s.interventions.size }.map {|k, vs| { intervention_count: k, student_count: vs.size } }
end  

# [{:intervention_type=>"After-School Tutoring (ATP)", :count=>30}]
def intervention_types
  Student.all.map {|s| s.interventions }.flatten.group_by(&:intervention_type).map {|k, vs| { intervention_type: k.name, count: vs.size } }
end


# [{:assessment_key=>"STAR-Reading", :count=>360},
#  {:assessment_key=>"STAR-Math", :count=>360},
#  {:assessment_key=>"ACCESS", :count=>150},
#  {:assessment_key=>"DIBELS", :count=>150},
#  {:assessment_key=>"MCAS-ELA", :count=>150},
#  {:assessment_key=>"MCAS-Math", :count=>150}]
def assessment_buckets(students, options = {})
  all_assessments = students.map(&:student_assessments).flatten
  all_assessments.group_by(&:assessment).map do |assessment, students|
    assessment_key = if assessment.subject
      [assessment.family, assessment.subject].join('-')
    else
      assessment.family
    end
    { assessment_key: assessment_key, count: students.size }
  end
end

def normalize_assessment_frequency(students_with_race, count_buckets)
  student_count = students_with_race.size
  count_buckets.map do |count_bucket|
    percentage = (count_bucket[:count] / student_count).round 2
    count_bucket.merge(percentage: percentage)
  end
end

def assessment_profile(options = {})
  output = []
  output << { label: 'all', assessment_buckets: assessment_buckets(Student.all, options) }
  Student.all.map(&:race).uniq.each do |race|
    students_with_race = Student.select {|s| s.race == race }
    assessment_buckets = assessment_buckets(students_with_race, options)
    normalized_buckets = normalize_assessment_frequency(students_with_race, assessment_buckets)
    output << { label: race, assessment_buckets: normalized_buckets }
  end
  output
end


# [{:label=>"all",
#   :risk_buckets=>
#    [{:level=>0, :count=>7, :percentage=>0.23},
#     {:level=>1, :count=>0, :percentage=>0.0},
#     {:level=>2, :count=>6, :percentage=>0.2},
#     {:level=>3, :count=>17, :percentage=>0.57}]},
#  {:label=>"W",
#   :risk_buckets=>
#    [{:level=>0, :count=>1, :percentage=>0.11},
#     {:level=>1, :count=>0, :percentage=>0.0},
#     {:level=>2, :count=>1, :percentage=>0.11},
#     {:level=>3, :count=>7, :percentage=>0.78}]},
#  {:label=>"B",
#   :risk_buckets=>
#    [{:level=>0, :count=>0, :percentage=>0.0},
#     {:level=>1, :count=>0, :percentage=>0.0},
#     {:level=>2, :count=>3, :percentage=>0.5},
#     {:level=>3, :count=>3, :percentage=>0.5}]},
#  {:label=>"H",
#   :risk_buckets=>
#    [{:level=>0, :count=>5, :percentage=>0.45},
#     {:level=>1, :count=>0, :percentage=>0.0},
#     {:level=>2, :count=>2, :percentage=>0.18},
#     {:level=>3, :count=>4, :percentage=>0.36}]},
#  {:label=>"A",
#   :risk_buckets=>
#    [{:level=>0, :count=>1, :percentage=>0.25},
#     {:level=>1, :count=>0, :percentage=>0.0},
#     {:level=>2, :count=>0, :percentage=>0.0},
#     {:level=>3, :count=>3, :percentage=>0.75}]}]
def risk_level_buckets(students, options = {})
  groups = students.group_by{|s| s.student_risk_level.level }
  level_counts = groups.map {|level, ss| { level: level, count: ss.count } }
  missing_levels = [0, 1, 2, 3] - level_counts.map {|level_count| level_count[:level] }
  all_level_counts = level_counts + missing_levels.map {|missing_level| { level: missing_level, count: 0 } }
  sorted_risk_buckets = all_level_counts.sort_by {|level_count| level_count[:level] }
  if options[:normalize]
    normalize_count_buckets(sorted_risk_buckets)
  else
    sorted_risk_buckets
  end
end

def normalize_count_buckets(count_buckets)
  student_count = count_buckets.reduce(0) {|sum, count_bucket| sum + count_bucket[:count] }.to_f
  count_buckets.map do |count_bucket|
    percentage = (count_bucket[:count] / student_count).round 2
    count_bucket.merge(percentage: percentage)
  end
end

def risk_profile(options = {})
  output = []
  output << { label: 'all', risk_buckets: risk_level_buckets(Student.all, options) }
  Student.all.map(&:race).uniq.each do |race|
    students_with_race = Student.select {|s| s.race == race }
    output << { label: race, risk_buckets: risk_level_buckets(students_with_race, options) }
  end
  output
end


# print out profiles of different distributions
def main
  risk_profile = risk_profile(:normalize => true)
  assessment_profile = assessment_profile(:normalize => true)
  puts "--- RISK PROFILE ---"
  pp risk_profile
  puts
  puts
  puts "--- ASSESSMENT PROFILE ---"
  pp assessment_profile
  nil
end
