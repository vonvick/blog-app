require 'rails_helper'

RSpec.describe Playlist, type: :model do
  # Association test
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to have_many(:ratings) }
  it { is_expected.to have_and_belong_to_many(:songs) }

  # Validation tests
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }

  describe 'when creating' do
    let!(:normal_role) { FactoryBot.create(:role, :user_role) }
    let!(:normal_user) { FactoryBot.create(:user, role: normal_role) }
    let!(:new_album) { FactoryBot.create(:album, created_by: normal_user) }
    let!(:new_song) { FactoryBot.create(:song, created_by: normal_user, album: new_album) }
    let!(:new_playlist) { FactoryBot.create(:playlist, owner: normal_user) }
    let!(:playlist_rating) { FactoryBot.create(:rating, rateable: new_playlist, created_by: normal_user) }

    it 'successfully creates an album with the correct user' do
      expect(new_playlist.user_id).to eq(normal_user.id)
    end

    it 'successfully adds a song to a playlist' do
      new_playlist.songs << new_song
      new_playlist.save
      expect(new_playlist.songs.last).to eq(new_song)
      expect(new_playlist.songs.count).to eq 1
    end

    it 'successfully adds a rating to a playlist' do
      expect(playlist_rating.rateable).to eq(new_playlist)
    end
  end
end
