require 'rails_helper'

RSpec.describe Role, type: :model do
  # Association test
  it { is_expected.to have_many(:users).with_foreign_key('role_id') }

  # Validation tests
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:rank) }
end
