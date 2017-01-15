require 'rails_helper'

describe User do
  it "should have a valid factory" do
    user = FactoryGirl.build(:user)
    expect(user).to be_valid
  end

  describe "Validation" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe "Association" do
    describe "profile" do
      it "user has_one" do
        profile = FactoryGirl.create(:profile)
        user = FactoryGirl.build(:user, profile: profile)
        expect(user.profile).to eq profile
      end
    end
  end

  describe "ClassMethods" do
    before :all do
      @mentors = create_list(:user, 3, :mentor)
      @mentees = create_list(:user, 4, :mentee)

      @mentors.each_with_index do |mentor, index|
        not_available = (index == 0 ? true : false)
        FactoryGirl.create(:profile, user: mentor, not_available: not_available)
      end

      @mentees.each_with_index do |mentee, index|
        not_available = (index == 0 ? true : false)
        FactoryGirl.create(:profile, user: mentee, not_available: not_available)
      end

      @available_mentors = User.mentors
      @available_mentees = User.mentees
    end

    describe "#Mentors" do
      it "lists all available mentors" do
        expect(@available_mentors.count).to eq 2
      end

      it "doesn't list mentees" do
        expect(@available_mentors).not_to include @mentees[0]
      end

      it "lists mentors" do
        expect(@available_mentors).to include @mentors[1]
      end

      it "doesn't list unavailable mentors" do
        expect(@available_mentors).not_to include @mentors[0]
      end

    end
    describe "#Mentees" do
      it "lists all available mentees" do
        expect(@available_mentees.count).to eq 3
      end

      it "doesn't list mentors" do
        expect(@available_mentees).not_to include @mentors[1]
      end

      it "lists mentors" do
        expect(@available_mentees).to include @mentees[1]
      end
      it "doesn't list unavailable mentees" do
        expect(@available_mentees).not_to include @mentees[0]
      end
    end
  end

end