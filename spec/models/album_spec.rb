require 'rails_helper'

RSpec.describe Album, type: :model do
  # Association test
  it { is_expected.to belong_to(:created_by) }

  # Validation tests
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:artist) }
  it { is_expected.to validate_presence_of(:year) }

  describe 'when creating' do
    let!(:admin_role) { FactoryBot.create(:role, :super_admin) }
    let!(:admin_user) { FactoryBot.create(:user, role: admin_role) }
    let!(:new_album) { FactoryBot.create(:album, created_by: admin_user) }

    it 'successfully creates an' do
      expect(new_album.user_id).to eq(admin_user.id)
    end
  end
end
