class Mentee::PagesController < Mentee::MenteeController
  before_action :authenticate_sign_in!
  def home
  end

  def authenticate_sign_in!
    redirect_to :back unless current_user
  end
end