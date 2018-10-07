require 'rails_helper'

RSpec.describe Rating, type: :model do
  # Association test
  it { is_expected.to belong_to(:created_by) }
  it { is_expected.to belong_to(:rateable) }

  # Validation tests
  it { is_expected.to validate_presence_of(:rating_score) }

  describe 'when creating' do
    subject { Rating }
    let!(:admin_role) { FactoryBot.create(:role, :super_admin) }
    let!(:admin_user) { FactoryBot.create(:user, role: admin_role) }
    let!(:new_album) { FactoryBot.create(:album, created_by: admin_user) }
    let!(:album_rating) { FactoryBot.create(:rating, rateable: new_album, created_by: admin_user) }

    let!(:second_user) { FactoryBot.create(:user, role: admin_role) }
    let!(:second_album_rating) { FactoryBot.create(:rating, rateable: new_album, created_by: second_user) }

    let!(:new_song) { FactoryBot.create(:song, created_by: admin_user, album: new_album) }
    let!(:song_rating) { FactoryBot.create(:rating, rateable: new_song, created_by: admin_user) }

    it 'successfully creates a rating for a new album' do
      expect(new_album.ratings.first.rating_score).to eq(album_rating.rating_score)
    end

    it 'successfully matches the correct rating for the album' do
      expect(new_album.ratings.last.rating_score).to eq(second_album_rating.rating_score)
    end

    it 'successfully matches the correct album for the rating' do
      expect(album_rating.rateable.title).to eq(new_album.title)
    end

    it 'shows which type a rating belongs to' do
      expect(subject.last.rateable.class).to eq new_song.class
    end
  end
end
