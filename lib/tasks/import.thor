class Import < Thor
  desc "start", "Import data into your Student Insights instance"
  method_option :school,
    aliases: "-s",
    desc: "Scope by school local ID; use ELEM to import all elementary schools"
  method_option :district,
    aliases: "-d",
    desc: "Scope by school district / charter organization"
  method_option :first_time,
    type: :boolean,
    desc: "Fill up an empty database"
  method_option :recent_only,
    type: :boolean,
    desc: "For data update, only look at recent rows"

  def start
    require './config/environment'

    if options["school"].present?
      if options["district"] == "Somerville" && School.count == 0
        School.seed_somerville_schools
      end
      school_scope = School.find_by_local_id!(options["school"]).local_id  # Use find_by! to make sure
                                                                           # school exists in database
    end

    importers = Settings.new({
      district_scope: options["district"],
      school_scope: school_scope,
      first_time: options["first_time"],
      recent_only: options["recent_only"]
    }).configure

    importers.each do |i|
      begin
        if Rails.env.development?
          i.connect_transform_import_locally
        else
          i.connect_transform_import
        end
      rescue Exception => message
        puts message
      end
    end

    Student.update_risk_levels
    Homeroom.destroy_empty_homerooms

    puts "#{Student.count} students"
    puts "#{StudentAssessment.count} assessments"
    puts "#{DisciplineIncident.count} discipline incidents"
    puts "#{AttendanceEvent.count} attendance events"
    puts "#{Educator.count} educators"
  end
end
