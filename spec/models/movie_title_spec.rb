require "rails_helper"

describe MovieTitle do
  it { is_expected.to validate_presence_of(:version) }
  it { is_expected.to validate_presence_of(:title) }
end
