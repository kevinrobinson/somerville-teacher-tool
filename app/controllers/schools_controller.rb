class SchoolsController < ApplicationController

  before_action :authenticate_admin!

  def show
    @school = School.friendly.find(params[:id])
    attendance_queries = AttendanceQueries.new(@school)
    mcas_queries = McasQueries.new(@school)

    @top_absences = attendance_queries.top_5_absence_concerns_serialized
    @top_tardies = attendance_queries.top_5_tardy_concerns_serialized
    @top_mcas_math_concerns = mcas_queries.top_5_math_concerns_serialized
    @top_mcas_ela_concerns = mcas_queries.top_5_ela_concerns_serialized
  end

  def homerooms
    @school = School.friendly.find(params[:id])
    homerooms = @school.students.map(&:homeroom).compact.uniq
    homeroom_queries = HomeroomQueries.new(homerooms)

    limit = 5
    @top_absences = homeroom_queries.top_absences.first(limit)
    @top_tardies = homeroom_queries.top_tardies.first(limit)
    @top_mcas_math_concerns = homeroom_queries.top_mcas_math_concerns.first(limit)
    @top_mcas_ela_concerns = homeroom_queries.top_mcas_ela_concerns.first(limit)
  end

  def star_reading
    time_now = Time.now
    @serialized_data = {
      :students_with_star_reading => students_with_star_reading(time_now),
      :current_school_year => DateToSchoolYear.new(time_now).convert,
      :intervention_types => InterventionType.all
    }
  end

  def overview
    @use_fixtures = false      # Toggle between using demo development data
                               # and real data loaded in as a JSON fixture

    unless @use_fixtures
      @serialized_data = {
        :students => overview_students(Time.new),
        :intervention_types => InterventionType.all
      }
    else
      # To generate new fixture data, look at @serialized_data above and run that Rails code
      # on a console.
      # Take the printed JSON output, and use this JS to remove personal identifers:

      #   var firstNames = ["Aladdin", "Chip", "Daisy", "Mickey", "Minnie", "Donald", "Elsa", "Mowgli", "Olaf", "Pluto", "Pocahontas", "Rapunzel", "Snow", "Winnie"];
      #   var lastNames = ["Disney", "Duck", "Kenobi", "Mouse", "Pan", "Poppins", "Skywalker", "White"];
      #   ss.forEach(function(s) {
      #     delete s.student_address;
      #     s.first_name = firstNames[Math.floor(Math.random()* firstNames.length)];
      #     s.last_name = lastNames[Math.floor(Math.random()* lastNames.length)];
      #   })
      #   JSON.stringify(ss);

      # This data should still be considered private and not checked into source control, but doing a rough pass
      # to remove names is useful when working in a semi-public space.

      fixture_path = "#{Rails.root}/data/cleaned_all_ss.json"
      @serialized_data = IO.read(fixture_path).html_safe if File.exist? fixture_path
    end
  end

  private
  def students_with_star_reading(time_now)
    use_fixtures = true

    return IO.read("#{Rails.root}/data/students_with_star_reading.json") if use_fixtures
    
    # for generating data, or for   
    last_school_year = DateToSchoolYear.new(time_now - 1.year).convert
    clean_student_hashes Student.includes(:assessments).map do |student|
       student.as_json.merge(star_reading_results: s.star_reading_results.as_json)
    end
  end

  # remove sensitive-ish fields
  def clean_student_hashes(student_hashes)
    student_hashes.map do |student_hash|
      student_hash.except(:address).merge({
        first_name: ["Aladdin", "Chip", "Daisy", "Mickey", "Minnie", "Donald", "Elsa", "Mowgli", "Olaf", "Pluto", "Pocahontas", "Rapunzel", "Snow", "Winnie"].sample,
        last_name: ["Disney", "Duck", "Kenobi", "Mouse", "Pan", "Poppins", "Skywalker", "White"].sample
      })
    end
  end

  def overview_students(time_now)
    current_school_year = DateToSchoolYear.new(time_now).convert
    Student.includes(:interventions, :discipline_incidents).map do |student|
      student.as_json.merge({
        :interventions => student.interventions.as_json,
        :discipline_incidents_count => student.discipline_incidents.select do |incident|
          incident.school_year == current_school_year
        end.size
      })
    end
  end
end
