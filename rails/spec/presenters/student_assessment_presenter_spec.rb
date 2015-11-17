require 'rails_helper'

RSpec.describe StudentAssessmentPresenter do

  describe '#performance_level' do
    context 'assessment has no performance level' do
      let(:student_assessment) { FactoryGirl.create(:mcas_math_assessment) }
      let(:presenter) { StudentAssessmentPresenter.new(student_assessment) }
      it 'presents "—"' do
        expect(presenter.performance_level).to eq "—"
      end
    end
    context 'assessment has a performance level' do
      let(:student_assessment) { FactoryGirl.create(:mcas_math_warning_assessment) }
      let(:presenter) { StudentAssessmentPresenter.new(student_assessment) }
      it 'delegates the display to the assessment' do
        expect(presenter.performance_level).to eq "W"
      end
    end
  end

end
