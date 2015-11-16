require 'rails_helper'

RSpec.describe StudentAssessmentImporter do

  describe '#import' do
    context 'with good data' do
      let(:file) { File.open("#{Rails.root}/spec/fixtures/fake_x2_assessments.csv") }
      let(:transformer) { CsvTransformer.new }
      let(:csv) { transformer.transform(file) }

      context 'for Healey school' do
        let(:healey) { School.where(local_id: "HEA").first_or_create! }
        let(:healey_importer) { StudentAssessmentImporter.new(school: healey) }

        before(:each) do
          healey_importer.import(csv)
        end

        it 'creates a student' do
          expect(Student.count).to eq 1
        end

        it 'imports only white-listed assessments' do
          expect(StudentAssessment.count).to eq 7
        end

        context 'MCAS' do
          let(:assessments) { Assessment.where(family: "MCAS") }

          it 'creates MCAS Math and ELA assessments' do
            expect(assessments.count).to eq 2
            expect(assessments.first.subject).to eq "ELA"
            expect(assessments.last.subject).to eq "Math"
          end
          context 'Math' do
            it 'sets the scaled scores and performance levels, growth percentiles correctly' do
              mcas_assessment = assessments.where(subject: "Math").first
              mcas_student_assessment = mcas_assessment.student_assessments.last
              expect(mcas_student_assessment.scale_score).to eq(214)
              expect(mcas_student_assessment.performance_level).to eq('W')
              expect(mcas_student_assessment.growth_percentile).to eq(nil)
            end
          end
          context 'ELA' do
            it 'sets the scaled scores, performance levels, growth percentiles correctly' do
              mcas_assessment = assessments.where(subject: "ELA").first
              mcas_student_assessment = mcas_assessment.student_assessments.last
              expect(mcas_student_assessment.scale_score).to eq(222)
              expect(mcas_student_assessment.performance_level).to eq('NI')
              expect(mcas_student_assessment.growth_percentile).to eq(70)
            end
          end
        end

        context 'DIBELS' do
          let(:assessments) { Assessment.where(family: "DIBELS") }
          let(:assessment) { assessments.first }

          it 'creates assessment' do
            expect(assessments.count).to eq 1
          end
          it 'creates a student assessment' do
            results = assessment.student_assessments
            expect(results.count).to eq 1
          end
          it 'sets the performance levels correctly' do
            dibels_result = assessment.student_assessments.last
            expect(dibels_result.performance_level).to eq('Benchmark')
          end
        end

        context 'ACCESS' do
          let(:assessments) { Assessment.where(family: "ACCESS") }
          let(:assessment) { assessments.first }

          it 'creates assessment' do
            expect(assessments.count).to eq 1
          end
          it 'creates three student assessments' do
            results = assessment.student_assessments
            expect(results.count).to eq 3
          end
          it 'sets the scaled scores, performance levels, growth percentiles correctly' do
            last_access_result = assessment.student_assessments.last
            expect(last_access_result.scale_score).to eq(367)
            expect(last_access_result.performance_level).to eq('4.9')
            expect(last_access_result.growth_percentile).to eq(92)
          end
        end
      end
    end
  end
end
