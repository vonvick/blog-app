require 'rails_helper'

describe V1::RatingsController, type: :request do
  let!(:role) { FactoryBot.create(:role, :super_admin) }
  let!(:normal_role) { FactoryBot.create(:role, :user_role) }
  let(:user) { FactoryBot.create(:user, email: 'victor@example.com', password: 'password', role: role) }
  let(:second_user) do
    FactoryBot.create(:user, email: 'victorino@example.com', password: 'password', role: normal_role)
  end
  let!(:album) { FactoryBot.create(:album, created_by: user) }
  let!(:song) { FactoryBot.create(:song, created_by: user, album: album) }
  let!(:album_rating) { FactoryBot.create(:rating, rateable: album, created_by: user) }
  let!(:song_rating) { FactoryBot.create(:rating, rateable: song, created_by: user) }

  let!(:second_album_rating) { FactoryBot.create(:rating, rateable: album, created_by: second_user) }
  let!(:second_song_rating) { FactoryBot.create(:rating, rateable: song, created_by: second_user) }

  context 'when user is not logged in' do
    it 'does not create a song for the user' do
      delete "/v1/ratings/#{album_rating.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when user is logged in' do
    let!(:auth_headers) { user.create_new_auth_token }
    let!(:headers) do
      {
        'CONTENT_TYPE': 'application/json',
        'ACCEPT': 'application/json',
        'Uid': auth_headers['uid'],
        'Access-Token': auth_headers['access-token'],
        'Client': auth_headers['client']
      }
    end
    before do
      sign_in user
    end

    it 'deletes a rating by its id' do
      delete "/v1/ratings/#{album_rating.id}", headers: headers

      expect(Rating.find_by_id(album_rating.id).rating_score).to eq('unrated')
      expect(response).to have_http_status(:ok)
    end
  end
end
