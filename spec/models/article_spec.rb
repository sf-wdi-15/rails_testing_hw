require 'rails_helper'

RSpec.describe Article, :type => :model do
  
  describe "validations: " do
    it "should not save without a :title" do
      article = Article.create({content: "blah"})
        expect(article.save).to be(false)
      end

    it "should not save without content" do
      article = Article.create({title: "Title"})
      expect(article.save).to be(false)
    end

    it "title should be a minimum of three characters" do
      article = Article.create({title: "12", content: "content paragraph"})
      expect(article.save).to be(false)
    end

    it "content should be a minimum of 5 characters" do
      article = Article.create({title: "Title", content: "1234"})
      expect(article.save).to be(false)
    end
  end
end
