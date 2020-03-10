require 'rails_helper'

RSpec.describe SearchesController, :type => :controller do
  describe 'GET typeahead_search' do
    let(:typeahead_query) { 'Tuple pairing' }

    context 'the request is verified' do
      let(:results) do
        [{'_index'=>'episodes',
         '_type'=>'_doc',
         '_id'=>'1730713',
         '_score'=>10.4578905,
         '_source'=>
          {'id'=>1730713,
           'title'=>'62: Avoiding Negativity',
           'description'=> 'description',
           'publication_date'=>'2018-11-08T11:00:00.000Z',
           'podcast'=>{'itunes_image'=>'image_url'}}}]
      end

      before do
        allow(controller).to receive(:verified_request?).and_return(true)
        allow(Episode).to receive(:typeahead_search).with(typeahead_query).and_return(results)

        get :typeahead_search, params: { q: typeahead_query }
      end

      it 'assigns the query term to an instance variable' do
        expect(assigns(:typeahead_query)).to eq(typeahead_query)
      end

      it 'stores the query in an encrypted cookie' do
        expect(cookies.encrypted[:search_term]).to eq(typeahead_query)
      end

      it 'searches for the query term through Elasticsearch' do
        expect(Episode).to have_received(:typeahead_search).with(typeahead_query)
      end

      it 'renders the results as json' do
        expect(response.media_type).to eq('application/json')
      end

      it 'renders the results as a formatted Array for React typeahead_search' do
        formatted_results = [{'id'=>1730713,
                              'title'=>'62: Avoiding Negativity',
                              'description'=> 'description',
                              'publication_date'=>'2018-11-08T11:00:00.000Z',
                              'podcast'=>{'itunes_image'=>'image_url'}}]

        expect(response.body).to eq(formatted_results.to_json)
      end
    end

    context 'the request is not verified' do
      before do
        get :typeahead_search, params: { q: typeahead_query }
      end

      it 'renders an empty json response' do
        expect(response.body).to eq({}.to_json)
      end

      it 'responds with http status code 403' do
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'GET main_search' do
    let(:main_query) { 'Tuple pairing' }
    let(:results) do
      [{'_index'=>'episodes',
       '_type'=>'_doc',
       '_id'=>'1730713',
       '_score'=>10.4578905,
       '_source'=>
        {'id'=>1730713,
         'title'=>'62: Avoiding Negativity',
         'description'=> 'description',
         'publication_date'=>'2018-11-08T11:00:00.000Z',
         'podcast'=>{'itunes_image'=>'image_url'}}}]
    end

    before do
      allow(Episode).to receive(:main_search).with(main_query).and_return(results)
      get :main_search, params: { q: main_query }
    end

    it 'assigns the query term to an instance variable' do
      expect(assigns(:main_query)).to eq(main_query)
    end

    it 'stores the query in an encrypted cookie' do
      expect(cookies.encrypted[:search_term]).to eq(main_query)
    end

    it 'does not verify CSRF tokens' do
      request.headers.merge! headers: { 'X-CSRF-Token' => 'wrong' }
      expect(response.status).to eq(200)
    end

    it 'assigns the formatted search results to an instance variable' do
      formatted_results = [{'id'=>1730713,
                            'title'=>'62: Avoiding Negativity',
                            'description'=> 'description',
                            'publication_date'=>'2018-11-08T11:00:00.000Z',
                            'podcast'=>{'itunes_image'=>'image_url'}}]

      expect(assigns(:search_result_props)).to eq(formatted_results)
    end

    it 'renders the show page' do
      expect(response).to render_template(:show)
    end
  end
end
