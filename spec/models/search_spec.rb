require 'spec_helper'

describe Search do
  describe "without groups" do
    it "should be a valid search" do
      search = FactoryGirl.create :search
      search.groups = [] 
      search.save!
      search.should be_valid
    end
  end
  describe "with groups" do
    it "should be a valid search" do
      search = FactoryGirl.create :search
      search.should be_valid
    end
  end
  describe "run!" do
    it "sets search_errors and search_results to nil" do
      search = FactoryGirl.create :search
      search.should_receive("update_attributes").with({ :search_errors => nil, :search_results => nil})
      SearchWorker.stub("perform_async")
      search.run!
    end
    it "should call perform_async on SearchWorker with search" do
      search = FactoryGirl.create :search
      SearchWorker.should_receive("perform_async").with(search.id)
      search.run!
    end
  end
  describe "groups_to_sentence" do
    it "should return a sentence" do
      search = FactoryGirl.create :search
      search.groups_to_sentence.should == "BUSOPS and SISMAT"
    end
  end
  describe "search with errors" do
    it "should be finished" do
      search = FactoryGirl.create :search
      search.search_errors = "Some error"
      search.save!
      search.finished?.should be_true
    end
  end

  describe "search with results" do
    it "should be finished" do
      search = FactoryGirl.create :search
      search.search_results = "Some result"
      search.save!
      search.finished?.should be_true
    end
  end
end
