require 'spec_helper'

describe "hour bars" do
  before(:each) do
    RubyCAS::Filter.fake("user")
    @room1 = create(:room)
  end
  context "when there are no hours" do
    before(:each) do
      visit root_path
    end
    it "should lock everything down" do
      expect(page).to have_selector(".bar-danger", :count => 1)
    end
    context "and there are reservations" do
      before(:each) do
        create(:reservation, :start_time => Time.current.midnight, :end_time => Time.current.midnight+2.hours, :room => @room1)
        visit root_path
      end
      it "should only show one bar - the hours bar" do
        expect(page).to have_selector(".bar-danger", :count => 1)
      end
    end
  end
  context "when there are hours" do
    context "and those hours aren't special" do
      before(:each) do
        create(:special_hour, open_time: "06:00:00", close_time: "14:00:00")
        visit root_path
      end
      it "should create two bars locking down available reservation times to those hours" do
        expect(page).to have_selector(".bar-danger", :count => 2)
      end
      context "and a reservation exists within that timeslot" do
        before(:each) do
          create(:reservation, :start_time => Time.current.midnight, :end_time => Time.current.midnight+2.hours, :room => @room1)
          visit root_path
        end
        it "should only display the hours" do
          expect(page).to have_selector(".bar-danger", :count => 2)
        end
      end
      context "and a reservation exists outside that timeslot" do
        before(:each) do
          create(:reservation, :start_time => Time.current.midnight+7.hours, :end_time => Time.current.midnight+9.hours, :room => @room1)
          visit root_path
        end
        it "should display both the hours and the reservation" do
          expect(page).to have_selector(".bar-danger", :count => 3)
        end
      end
    end
    context "and the hours lock the whole day down" do
      before(:each) do
        create(:special_hour, open_time: "01:00:00", close_time: "01:00:00")
        visit root_path
      end
      it "should only display one reservation bar" do
        expect(page).to have_selector(".bar-danger", :count => 1)
      end
    end
    context "and the hours only lock down after a certain point" do
      before(:each) do
        create(:special_hour, open_time: "00:15:00", close_time: "12:00:00")
        visit root_path
      end
      it "should only display one reservation bar" do
        expect(page).to have_selector(".bar-danger", :count => 1)
      end
    end
  end
  describe "caching", :caching => true do
    context "when hours change" do
      before(:each) do
        @hour = create(:special_hour, open_time: "00:15:00", close_time: "12:00:00")
        visit root_path
      end
      it "should change the number of bars if necessary" do
        expect(page).to have_selector(".bar-danger", :count => 1)
        @hour.open_time = "04:00:00"
        @hour.close_time = "08:00:00"
        @hour.save
        visit root_path
        expect(page).to have_selector(".bar-danger", :count => 2)
      end
    end
    context "when a reservation changes" do
      before(:each) do
        @hour = create(:special_hour, open_time: "00:15:00", close_time: "22:00:00")
        @r = create(:reservation, :start_time => Time.current.midnight, :end_time => Time.current.midnight+2.hours, :room => @room1)
        visit root_path
      end
      it "should update the cache" do
        expect(page).to have_selector(".bar-danger", :count => 2)
        @r.destroy
        visit root_path
        expect(page).to have_selector(".bar-danger", :count => 1)
      end
    end
  end
end