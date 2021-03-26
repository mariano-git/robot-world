require "rails_helper"

RSpec.describe Api::V1::Factory::CarController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/factory/car").to route_to("api/v1/factory/car#index")
    end

    it "routes to #show" do
      expect(get: "/api/v1/factory/car/1").to route_to("api/v1/factory/car#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/api/v1/factory/car").to route_to("api/v1/factory/car#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/factory/car/1").to route_to("api/v1/factory/car#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/factory/car/1").to route_to("api/v1/factory/car#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/factory/car/1").to route_to("api/v1/factory/car#destroy", id: "1")
    end
  end
end
