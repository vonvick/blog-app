require 'rails_helper'

describe V1::PlaylistController, type: :request do
  let!(:role) { FactoryBot.create(:role, :super_admin) }
  let!(:normal_role) { FactoryBot.create(:role, :user_role) }
  let(:user) { FactoryBot.create(:user, email: 'victor@example.com', password: 'password', role: role) }
  let(:second_user) do
    FactoryBot.create(:user, email: 'victorino@example.com', password: 'password', role: normal_role)
  end
  let!(:album) { FactoryBot.create(:album, created_by: user) }
  let!(:songs) { FactoryBot.create_list(:song, 5, created_by: user, album: album) }
  let(:song_ids) { songs.pluck(:id) }

  let(:playlist_params) do
    {
      playlist: {
        title: 'My first playlist',
        description: 'A playlist of Nigerian songs'
      }
    }.to_json
  end

  context 'when user is not logged in' do
    it 'does not create a album for the user' do
      post '/v1/playlist', params: playlist_params
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
    let!(:new_playlist) { FactoryBot.create(:playlist, owner: user) }
    let!(:second_playlist) { FactoryBot.create(:playlist, owner: user) }
    let!(:third_playlist) { FactoryBot.create(:playlist, owner: second_user) }
    let!(:playlist_with_songs) do
      new_playlist.songs << songs
      new_playlist
    end
    before do
      sign_in user
    end

    it 'creates song by an admin' do
      post '/v1/playlist', params: playlist_params, headers: headers

      expect(response).to have_http_status(:created)
    end

    it 'updates a album by an admin' do
      put "/v1/playlist/#{new_playlist.id}",
          params: { playlist: { title: 'Afro Pop playlist' } }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:data][:title]).to eq('Afro Pop playlist')
    end

    it 'gets all created playlist' do
      get '/v1/playlist/', headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:data].count).to eq 3
    end

    it 'gets a playlist' do
      get "/v1/playlist/#{new_playlist.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:data][:title]).to eq new_playlist.title
    end

    it 'gets all playlist for a particular user' do
      get "/v1/playlist/user/#{user.id}", headers: headers

      expect(json[:data].count).to eq 2
    end

    it 'adds songs to a playlist' do
      put "/v1/playlist/add_song/#{new_playlist.id}",
          headers: headers,
          params: {
            playlist: {
              song_ids: song_ids
            }
          }.to_json

      expect(new_playlist.songs.count).to eq 5
    end

    it 'removes songs from a playlist' do
      delete "/v1/playlist/remove_song/#{new_playlist.id}",
             headers: headers,
             params: {
               playlist: {
                 song_ids: [song_ids[2], song_ids[4]]
               }
             }.to_json

      expect(new_playlist.songs.count).to eq 3
    end

    it 'sets a rating for a playlist' do
      put "/v1/playlist/#{third_playlist.id}/ratings",
          params: {
            rating: {
              rating_score: 3, rateable_id: third_playlist.id, rateable_type: 'playlist'
            }
          }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:data][:rating_score]).to eq('good')
    end

    it 'deletes a album by an admin' do
      delete "/v1/playlist/#{new_playlist.id}", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end
end
