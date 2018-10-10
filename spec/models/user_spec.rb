require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  it { is_expected.to belong_to(:role) }
  it { is_expected.to have_many(:albums).with_foreign_key('user_id') }

  # Validation tests
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  describe 'when creating' do
    let!(:admin_role) { FactoryBot.create(:role, :admin) }
    let!(:admin_user) { FactoryBot.create(:user, role: admin_role) }

    it 'successfully creates a user' do
      expect(admin_user.role.id).to eq(admin_role.id)
    end
  end
end
