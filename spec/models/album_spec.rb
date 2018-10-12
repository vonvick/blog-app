require 'rails_helper'

RSpec.describe Album, type: :model do
  # Association test
  it { is_expected.to belong_to(:created_by) }
  it { is_expected.to have_many(:ratings) }

  # Validation tests
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:artist) }
  it { is_expected.to validate_presence_of(:year) }

  describe 'when creating' do
    let!(:admin_role) { FactoryBot.create(:role, :admin) }
    let!(:admin_user) { FactoryBot.create(:user, role: admin_role) }
    let!(:new_album) { FactoryBot.create(:album, created_by: admin_user) }
    let!(:album_rating) { FactoryBot.create(:rating, rateable: new_album, created_by: admin_user) }

    it 'successfully creates an album with the correct user' do
      expect(new_album.user_id).to eq(admin_user.id)
    end

    it 'successfully adds a rating to an album' do
      expect(new_album.ratings.last).to eq(album_rating)
    end
  end
end
