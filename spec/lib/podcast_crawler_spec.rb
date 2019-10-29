require 'rails_helper'

RSpec.describe Crawler::PodcastCrawler do
  let(:podcast) { Podcast.new(title: 'The Daily', rss: 'https://rss.art19.com/the-daily', itunes_image: 'not_available') }
  let(:subject) { described_class.new(podcast) }

  describe '#update_podcast_info' do
    let(:description) { "\n      <p>This is what the news should sound like. The biggest stories of our time, told by the best journalists in the world. Hosted by Michael Barbaro. Twenty minutes a day, five days a week, ready by 6 a.m.</p>\n    " } 
    let(:image_link) { 'https://content.production.cdn.art19.com/images/01/1b/f3/d6/011bf3d6-a448-4533-967b-e2f19e376480/7fdd4469c1b5cb3b66aa7dcc9fa21f138efe9a0310a8a269f3dcd07c83a552844fcc445ea2d53db1e55d6fb077aeaa8a1566851f8f2d8ac4349d9d23a87a69f5.jpeg' }

    let(:podcast_attributes) do
      { title: 'The Daily', 
        description: description,
        language: 'en',
        website: 'https://www.nytimes.com/the-daily',
        itunes_owner_name: 'The New York Times',
        itunes_owner_email: 'thedaily@nytimes.com',
        itunes_explicit: false,
        itunes_subtitle: nil,
        itunes_summary: description,
        itunes_author: 'The New York Times',
        itunes_image: image_link
      }
    end

    it 'updates the podcast with the right attributes' do
      allow(podcast).to receive(:update).with(podcast_attributes)

      VCR.use_cassette('the-daily-rss-feed') do
        subject.update_podcast_info
        expect(podcast).to have_received(:update).with(podcast_attributes)
      end
    end

    context 'when the content is explicit' do
      let(:podcast) { Podcast.new(title: 'The Joe Rogan Experience', rss: 'http://joeroganexp.joerogan.libsynpro.com/rss', itunes_image: 'not_available') }

      it 'sets itunes_explicit to true' do
        VCR.use_cassette('joe-rogan-rss-feed') do
          subject.update_podcast_info
          expect(podcast.itunes_explicit).to be_truthy
        end
      end
    end
  end
end
