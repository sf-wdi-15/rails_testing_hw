require 'rails_helper'

RSpec.describe User, :type => :model do
  
  describe "validations" do
    
    it "should confirm a user :email" do
      user = User.new({email: "good_email", email_confirmation: "bad_email"})
      expect(user.save).to be(false)
    end

    it "should confirm a user :password" do
      user = User.new({password: "good_password", password_confirmation: "bad_password"})
      expect(user.save).to be(false)
    end

    it "should not create a user with a blank password" do
      user = User.new({email: "good_email", email_confirmation: "good_email"})
      expect(user.save).to be(false)
    end

    it "should not create a  user with a blank email" do
      user = User.new({password: "good_password", password_confirmation: "good_password"})
      expect(user.save).to be(false)
    end

    it "should require :password_confirmation" do
      user = User.new({email: "good_email", email_confirmation: "good_email", password: "good_password"})
      expect(user.save).to be(false)
    end

    it "should require :email_confirmation" do
      user = User.new({email: "good_email", password: "good_password", password_confirmation: "good_password"})
      expect(user.save).to be(false)
    end

    it "should validate :password length to be greater than 8 characters" do
      user = User.new ({email: "good_email", password: "1234567", password_confirmation: "1234567"})
      expect(user.save).to be(false)
    end
  end

  describe "self.confirm" do
    it "should return false when user doesn't exist" do
      expect(User.confirm("blahblah", "blahblah")).to be(nil)
    end

    it "should return false when user password is incorrect" do
      user = User.create({
                          email: "blah@blah.com",
                          email_confirmation: "blah@blah.com",
                          password: "blahBLAH",
                          password_confirmation: "blahBLAH"
                        })
      expect(User.confirm("blah@blah.com", "blahblah")).to be(false)
    end

    it "should return user when password is correct" do
      user = User.create({
                          email: "blah@blah2.com",
                          email_confirmation: "blah@blah2.com",
                          password: "blahBLAH",
                          password_confirmation: "blahBLAH"
                        })
      expect(User.confirm("blah@blah2.com", "blahBLAH")).to eq(user)
    end
  end
end
