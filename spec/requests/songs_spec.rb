require 'rails_helper'

describe V1::SongsController, type: :request do
  let(:url) { '/v1/songs' }
  let!(:role) { FactoryBot.create(:role, :admin) }
  let(:user) { FactoryBot.create(:user, email: 'victor@example.com', password: 'password', role: role) }
  let!(:album) { FactoryBot.create(:album, created_by: user) }
  let(:song_params) do
    {
      song: {
        title: 'Remind me',
        track: '1',
        artist: 'Simi',
        genre: 'RnB',
        album_id: album.id
      }
    }.to_json
  end

  context 'when user is not logged in' do
    it 'does not create a song for the user' do
      post url, params: song_params
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
    let!(:new_song) { FactoryBot.create(:song, created_by: user, album: album) }
    before do
      sign_in user
    end

    it 'creates song by an admin' do
      post url, params: song_params, headers: headers

      expect(response).to have_http_status(:created)
    end

    it 'updates a song by an admin' do
      put "/v1/songs/#{new_song.id}",
          params: { song: { title: 'joromi', album_id: album.id } }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:song][:title]).to eq('joromi')
    end

    it 'sets a rating for the song' do
      put "/v1/songs/#{new_song.id}/song/ratings",
          params: { rating: { rating_score: 3, rateable_id: new_song.id, rateable_type: 'song' } }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:rating][:rating_score]).to eq('good')
    end

    it 'gets all songs created' do
      get '/v1/songs', headers: headers

      # binding.pry
      expect(response).to have_http_status(:ok)
      expect(json[:songs].length).to eq 1
    end

    it 'updates the song count when the user plays the song' do
      put "/v1/songs/#{new_song.id}/play_count",
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:message]).to eq('Song count updated')
    end

    it 'deletes a song by an admin' do
      delete "/v1/songs/#{new_song.id}", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end
end
