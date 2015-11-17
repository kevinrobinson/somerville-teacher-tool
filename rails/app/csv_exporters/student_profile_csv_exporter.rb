class StudentProfileCsvExporter < Struct.new :student
  include FindDataForStudentProfile
  require 'csv'

  def student_assessments
    student.student_assessments
  end

  def profile_csv_export
    CSV.generate do |csv|
      demographic_section(csv).add
      attendance_section(csv).add
      behavior_section(csv).add
      mcas_math_section(csv).add
      mcas_ela_section(csv).add
      star_math_section(csv).add
      star_reading_section(csv).add
    end
  end

  def demographic_section(csv)
    StudentProfileCsvDemographicSection.new(csv, self)
  end

  def attendance_section(csv)
    StudentProfileCsvAttendanceSection.new(csv, self)
  end

  def behavior_section(csv)
    StudentProfileCsvBehaviorSection.new(csv, self)
  end

  def mcas_math_section(csv)
    StudentProfileCsvStudentAssessmentSection.new(
      csv, mcas_math_results(student), ["MCAS Math"],
      ['Date', 'Scale Score', 'Growth', 'Performance Level'],
      [:date_taken, :scale_score, :growth_percentile, :performance_level]
    )
  end

  def mcas_ela_section(csv)
    StudentProfileCsvStudentAssessmentSection.new(
      csv, mcas_ela_results(student), ["MCAS English Language Arts"],
      ['Date', 'Scale Score', 'Growth', 'Performance Level'],
      [:date_taken, :scale_score, :growth_percentile, :performance_level]
    )
  end

  def star_math_section(csv)
    StudentProfileCsvStudentAssessmentSection.new(
      csv, star_math_results(student), ["STAR Math"],
      ['Date', 'Math Percentile'],
      [:date_taken, :percentile_rank]
    )
  end

  def star_reading_section(csv)
    StudentProfileCsvStudentAssessmentSection.new(
      csv, star_math_results(student), ["STAR Reading"],
      ['Date', 'Reading Percentile', 'Instructional Reading Level'],
      [:date_taken, :percentile_rank, :instructional_reading_level]
    )
  end

end
