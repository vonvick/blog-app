require 'rails_helper'

describe V1::AlbumsController, type: :request do
  let(:url) { '/v1/albums' }
  let!(:role) { FactoryBot.create(:role, :admin) }
  let(:user) { FactoryBot.create(:user, email: 'victor@example.com', password: 'password', role: role) }
  let(:album_params) do
    {
      album: {
        title: 'Kamikaze',
        description: 'An album by eminem that talk about his life after releasing the 8th mile album',
        artist: 'Eminem',
        year: 2018
      }
    }.to_json
  end

  context 'when user is not logged in' do
    it 'does not create a album for the user' do
      post url, params: album_params
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
    let!(:new_album) { FactoryBot.create(:album, created_by: user) }
    before do
      sign_in user
    end

    it 'creates song by an admin' do
      post url, params: album_params, headers: headers

      expect(response).to have_http_status(:created)
    end

    it 'updates a album by an admin' do
      put "/v1/albums/#{new_album.id}",
          params: {
            album: {
              title: '8th Mile',
              description: new_album.description,
              artist: new_album.artist,
              year: new_album.year
            }
          }.to_json,
          headers: headers
      expect(response).to have_http_status(:ok)
      expect(json[:album][:title]).to eq('8th Mile')
    end

    it 'sets a rating for the album' do
      put "/v1/albums/#{new_album.id}/album/ratings",
          params: { rating: { rating_score: 3, rateable_id: new_album.id, rateable_type: 'album' } }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:rating][:rating_score]).to eq('good')
    end

    it 'gets all album created' do
      get '/v1/albums', headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:albums].length).to eq 1
    end

    it 'deletes a album by an admin' do
      delete "/v1/albums/#{new_album.id}", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end
end
