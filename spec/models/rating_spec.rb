require "rails_helper"

describe Rating do
  it { is_expected.to validate_presence_of(:movie) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_inclusion_of(:rating).to_allow(1..10).on(:create) }
  it { is_expected.to validate_uniqueness_of(:movie_id).scoped_to(:user_id).on(:create) }
end
