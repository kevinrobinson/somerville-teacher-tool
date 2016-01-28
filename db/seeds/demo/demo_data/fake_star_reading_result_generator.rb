class FakeStarReadingResultGenerator

  def initialize(student)
    @test_date = DateTime.now - rand(0..40)
    @student = student
    @instructional_reading_level = @student.grade.to_f
    @reading_percentile = rand(10..99)
  end

  def next
    @reading_percentile += rand(-15..15)
    @reading_percentile = [0, @reading_percentile, 100].sort[1]
    @instructional_reading_level += rand(-1..1)
    @test_date -= rand(0..40) # days

    return {
      assessment_id: Assessment.star_reading.id,
      date_taken: @test_date,
      percentile_rank: @reading_percentile,
      instructional_reading_level: @instructional_reading_level,
      student_id: @student.id
    }
  end
end
