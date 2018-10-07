require 'rails_helper'

RSpec.describe Song, type: :model do
  # Association test
  it { is_expected.to belong_to(:created_by) }
  it { is_expected.to have_many(:ratings) }

  # Validation tests
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:artist) }
  it { is_expected.to validate_presence_of(:track) }
  it { is_expected.to validate_presence_of(:genre) }
  it { is_expected.to validate_presence_of(:play_count) }

  describe 'when creating' do
    let!(:admin_role) { FactoryBot.create(:role, :super_admin) }
    let!(:admin_user) { FactoryBot.create(:user, role: admin_role) }
    let!(:new_album) { FactoryBot.create(:album, created_by: admin_user) }
    let!(:new_song) { FactoryBot.create(:song, created_by: admin_user, album: new_album) }
    let!(:song_rating) { FactoryBot.create(:rating, rateable: new_song, created_by: admin_user) }

    it 'successfully creates a new song with the correct user' do
      expect(new_song.user_id).to eq(admin_user.id)
    end

    it 'new song has an associated album' do
      expect(new_song.album.id).to eq(new_album.id)
    end

    it 'displays correct rating if the song has been rated' do
      expect(new_song.ratings.last.rating_score).to eq(song_rating.rating_score)
    end
  end
end
