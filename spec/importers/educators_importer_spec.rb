require 'rails_helper'

RSpec.describe EducatorsImporter do

  describe '#import_row' do
    context 'good row' do
      context 'new educator' do

        context 'non-administrator' do

          context 'without homeroom' do
            let(:row) {
              { state_id: "500", local_id: "200", full_name: "Young, Jenny", login_name: "jyoung" }
            }
            it 'does not create an educator' do
              expect { described_class.new.import_row(row) }.to change(Educator, :count).by 0
            end
          end

          context 'with homeroom' do
            let(:homeroom) { FactoryGirl.create(:homeroom) }
            let(:homeroom_name) { homeroom.name }

            context 'without school local id' do
              let(:row) {
                {
                  state_id: "500",
                  local_id: "200",
                  full_name: "Young, Jenny",
                  login_name: "jyoung",
                  homeroom: homeroom_name
                }
              }
              it 'creates an educator' do
                expect { described_class.new.import_row(row) }.to change(Educator, :count).by 1
              end
              it 'sets the attributes correctly' do
                described_class.new.import_row(row)
                educator = Educator.last
                expect(educator.full_name).to eq("Young, Jenny")
                expect(educator.state_id).to eq("500")
                expect(educator.local_id).to eq("200")
                expect(educator.admin).to eq(false)
                expect(educator.email).to eq("jyoung@k12.somerville.ma.us")
              end

              context 'multiple educators' do
                let(:another_homeroom) { FactoryGirl.create(:homeroom) }
                let(:another_homeroom_name) { another_homeroom.name }
                let(:another_row) {
                  {
                    state_id: "501",
                    local_id: "201",
                    full_name: "Gardner, Dylan",
                    login_name: "dgardner",
                    homeroom: another_homeroom_name
                  }
                }
                it 'creates multiple educators' do
                  expect {
                    described_class.new.import_row(row)
                    described_class.new.import_row(another_row)
                  }.to change(Educator, :count).by 2
                end
              end
            end

            context 'with school local ID' do
              let!(:healey) { FactoryGirl.create(:healey) }
              let(:row) {
                {
                  state_id: "500",
                  local_id: "200",
                  full_name: "Young, Jenny",
                  login_name: "jyoung",
                  homeroom: homeroom_name,
                  school_local_id: 'HEA'
                }
              }

              it 'assigns the educator to the correct school' do
                described_class.new.import_row(row)
                educator = Educator.last
                expect(educator.school).to eq(healey)
              end
            end

            context 'educator already exists' do
              let!(:educator) { FactoryGirl.create(:educator, :local_id_200) }

              let(:row) {
                {
                  state_id: "500",
                  local_id: "200",
                  full_name: "Young, Jenny",
                  login_name: "jyoung",
                  homeroom: homeroom_name
                }
              }

              it 'does not create an educator' do
                expect { described_class.new.import_row(row) }.to change(Educator, :count).by 0
              end
              it 'updates the educator attributes' do
                described_class.new.import_row(row)
                educator = Educator.last
                expect(educator.full_name).to eq("Young, Jenny")
                expect(educator.state_id).to eq("500")
              end
            end

          end
        end

        context 'administrator' do
          let(:row) {
            { local_id: "300", full_name: "Hill, Marian", staff_type: "Administrator", login_name: "mhill" }
          }

          it 'sets the administrator attribute correctly' do
            described_class.new.import_row(row)
            educator = Educator.last
            expect(educator.admin).to eq(true)
          end
        end

      end
    end
  end

  describe '#update_homeroom' do

    context 'row with homeroom name' do
      let(:row) {
        { state_id: "500", local_id: "200", full_name: "Young, Jenny", homeroom: "HEA 100", login_name: "jyoung" }
      }

      context 'name of homeroom that exists' do
        let!(:homeroom) { FactoryGirl.create(:homeroom, :named_hea_100) }
        it 'assigns the homeroom tho the educator' do
          described_class.new.import_row(row)
          expect(Educator.last.homeroom).to eq homeroom
        end
      end

      context 'name of homeroom that does not exist' do
        it 'raises an error' do
          expect { described_class.new.import_row(row) }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
