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

  describe 'validating fields' do
    subject do
      described_class.new(first_name: 'John', last_name: 'Samuel', username: 'vonj',
                          email: 'john.samuel@mail.com', uid: 'john.samuel@mail.com',
                          password: 'uirekdsfhew', password_confirmation: 'uirekdsfhew')
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a first_name' do
      subject.first_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a last_name' do
      subject.last_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with wrong email' do
      subject.email = 'uiewsdry12@uijdskfh'
      expect(subject).to_not be_valid
    end

    it 'sets uid to equal email' do
      expect(subject.uid).to eq(subject.email)
    end
  end

  describe 'when creating' do
    let!(:admin_role) { FactoryBot.create(:role, :admin) }
    let!(:admin_user) { FactoryBot.create(:user, role: admin_role) }

    it 'successfully creates a user' do
      expect(admin_user.role.id).to eq(admin_role.id)
    end
  end
end
