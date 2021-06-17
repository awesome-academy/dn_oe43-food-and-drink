require "rails_helper"

describe User do
  subject(:user) {FactoryBot.create :user}

  describe "Attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_token) }
  end

  describe "Associations" do
    it "should have many orders" do
      should have_many(:orders)
    end
    it "should have many ratings" do
      should have_many(:ratings)
    end
  end

  describe "Validations" do
    it { should validate_presence_of :name }

    it { should validate_length_of(:password).is_at_least(Settings.user.password.min_length) }

    it { should validate_presence_of :email }
    it { should validate_length_of(:email).is_at_most(Settings.user.email.max_length) }
    it { should allow_value("test@tes.t").for(:email) }
    it { should_not allow_value("test@test").for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe ".new_token" do
    it "return a new SecureRandom token" do
      User.new_token.should_not eq User.new_token
    end
  end

  describe ".digest" do
    it "crypt string to BCrypt::Password" do
      User.digest("a").class.should eq BCrypt::Password
    end

    it "crypt string even min_cost nil" do
      ActiveModel::SecurePassword.min_cost = nil
      User.digest("a").class.should eq BCrypt::Password
    end
  end

  describe "#remember" do
    it "update remember_digest with a new BCrypt::Password
     as a string with length 60" do
      user.remember
      user.remember_digest.length.should eq 60
    end
  end

  describe "#forget" do
    it "update remember_digest to nil" do
      user.forget
      user.remember_digest.should nil
    end
  end

  describe "#authenticated?" do
    it "return true if remember_digest is remember_token digested" do
      remember_token = User.new_token
      user.update_column :remember_digest, User.digest(remember_token)
      user.authenticated?(remember_token).should be true
    end

    it "return false if remember_digest is not remember_token" do
      remember_token = User.new_token
      user.update_column :remember_digest, User.digest(remember_token)
      user.authenticated?(User.new_token).should_not be true
    end
  end

  describe "#downcase_email" do
    it "should be save with lowercase email" do
      user.email = "ABc@ab.Com"
      user.save
      user.email.should eq "abc@ab.com"
    end
  end

end
