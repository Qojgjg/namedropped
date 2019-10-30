require 'rails_helper'

RSpec.describe Crawler::PodcastCrawler do
  let(:podcast) { Podcast.new(title: 'The Daily', rss: 'https://rss.art19.com/the-daily', itunes_image: 'not_available', id: 1) }
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

  describe '#update_podcast_episodes_info' do
    let(:podcast) { Podcast.create(title: 'The Daily', rss: 'https://rss.art19.com/the-daily', itunes_image: 'not_available', id: 1) }
    let(:episode_description) do
      "\n        <p>At a rally in New York City last weekend, Senator Bernie Sanders drew the largest crowd of his presidential campaign — at a moment when his candidacy may be at its most vulnerable. After a heart attack this month, Mr. Sanders faced a challenge in convincing voters that he had the stamina to run both a campaign and the country. His first rally since his hospital stay attracted supporters still resentful of his loss in 2016, and of a party establishment they feel favored Hillary Clinton over Mr. Sanders in the primary. The question for Democratic candidates now is how to respond to this grievance and harness the fervor of Sanders supporters to mobilize support for the Democratic Party more broadly.</p><p>Guest: <a href=\"https://www.nytimes.com/by/alexander-burns?smid=pc-thedaily\" target=\"_blank\">Alexander Burns</a>, who covers national politics for The Times. For more information on today’s episode, visit <a href=\"https://www.nytimes.com/thedaily?smid=pc-thedaily\" target=\"_blank\">nytimes.com/thedaily</a>.&nbsp;</p><p>Background coverage:&nbsp;</p><ul><li>Revitalized by an endorsement from Representative Alexandria Ocasio-Cortez, Sanders proclaimed “I am back” as he<a href=\"https://www.nytimes.com/2019/10/19/us/politics/bernie-sanders-aoc-queensbridge-park.html?searchResultPosition=3\" target=\"_blank\"> rebooted his campaign</a> after a health scare.</li><li><a href=\"https://www.nytimes.com/2019/10/23/nyregion/bernie-sanders-aoc-rally-queens.html?smid=pc-thedaily\" target=\"_blank\">The response to Sanders’s rally</a> from public housing residents in Queens exposed the race and class tensions in a gentrifying slice of New York City.&nbsp;</li></ul>\n      "
    end
    let(:guid) { "gid://art19-episode-locator/V0/Ok8umyE1r9eEadFtzblMGYAbqT6mgYKzirRyZkSB79o" }
    let(:enclosure_url) { "https://dts.podtrac.com/redirect.mp3/rss.art19.com/episodes/68cb81d3-0786-4dfa-83a1-0f9de7eaab83.mp3" }
    let(:episode_attributes) do
      {
        title: "‘A Prophet’: The Zeal of Bernie Sanders Supporters",
        description: episode_description,
        link_to_website: nil,
        guid: guid,
        publication_date: DateTime.new(2019, 10, 25, 9, 52, 10),
        enclosure_url: enclosure_url,
        enclosure_length: "28046315",
        enclosure_type: "audio/mpeg",
        itunes_explicit: false,
        itunes_duration: 1752
      }
    end

    let(:episodes) { instance_double('episodes') }

    it 'creates an episode for each item in the feed' do
      VCR.use_cassette('the-daily-rss-feed') do
        subject.update_podcast_episodes_info

        expect(podcast.episodes.count).to eq(721)
      end
    end

    it 'sets the right attributes on each episode' do
      VCR.use_cassette('the-daily-rss-feed') do
        allow(podcast).to receive(:episodes).and_return(episodes)
        allow(episodes).to receive(:create)
        subject.update_podcast_episodes_info

        expect(episodes).to have_received(:create).exactly(721).times
      end
    end

    context 'when the content is explicit' do
      let(:podcast) { Podcast.create(title: 'The Joe Rogan Experience', rss: 'http://joeroganexp.joerogan.libsynpro.com/rss', itunes_image: 'not_available') }

      it 'sets itunes_explicit to true' do
        VCR.use_cassette('joe-rogan-rss-feed') do
          subject.update_podcast_episodes_info
          expect(podcast.episodes.last.itunes_explicit).to be_truthy
        end
      end
    end
  end
end
