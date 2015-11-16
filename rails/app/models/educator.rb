class Educator < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable
  has_one :homeroom
  has_many :students, through: :homerooms
  has_many :interventions
  has_many :progress_notes, through: :interventions

  def allowed_homerooms
    # Educator can visit roster view for these homerooms
    # For non-admins, all homerooms at their homeroom's grade level

    if admin?
      Homeroom.all
    else
      # Once the app includes data for multiple schools, will
      # need to scope by school as well as by grade level
      Homeroom.where(grade: homeroom.grade)
    end
  end

  def allowed_homerooms_by_name
    allowed_homerooms.order(:name)
  end

end
