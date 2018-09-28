require 'rails_helper'

RSpec.describe Role, type: :model do
  # Association test
  it { should have_many(:users).with_foreign_key('role_id') }

  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:rank) }
end