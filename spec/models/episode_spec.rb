require 'rails_helper'

RSpec.describe Episode, elasticsearch: true, type: :model do
  it 'should initially have no Episode records' do
    expect(Episode.search('*:*').records.length).to eq(0)
  end

  it 'should index the new object in Elasticsearch after the object was created' do
    FactoryBot.create(:episode)

    Episode.__elasticsearch__.refresh_index!
    expect(Episode.search("Nick Gillespie").records.length).to eq(1)
  end

  it 'should update the Elasticsearch index when the object is destroyed' do
    episode = FactoryBot.create(:episode)
    episode.destroy!
    expect(Episode.search("Nick Gillespie").records.length).to eq(0)
  end
end
