require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#alert_class_for" do
    it "returns alert-success when it receives success" do
      expect(alert_class_for(:success)).to eq("alert-success")
    end

    it "returns alert-danger when it receives error" do
      expect(alert_class_for(:error)).to eq("alert-danger")
    end

    it "returns alert-warning when it receives alert" do
      expect(alert_class_for(:alert)).to eq("alert-warning")
    end

    it "returns alert-info when it receives notice" do
      expect(alert_class_for(:notice)).to eq("alert-info")
    end
  end
end
