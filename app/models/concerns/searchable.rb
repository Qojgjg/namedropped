module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def as_indexed_json(_options = {})
      as_json(only: [:title, :description, :publication_date, :id], include: { podcast: { only: :itunes_image} })
    end

    settings do
      mappings dynamic: false do
        indexes :id, type: :integer
        indexes :title, type: :text, analyzer: :english
        indexes :description, type: :text, analyzer: :english
        indexes :publication_date, type: :date
      end
    end

    def self.typeahead_search(query)
      search_definition =  {
        sort: {publication_date: {order: :desc}},
        query: {
          multi_match: {
            query: query,
            type: :phrase,
            fields: [:title, :description]
          },
        }
      }

      __elasticsearch__.search(search_definition)
    end

    def self.main_search(query)
      search_definition =  {
        size: 100,
        sort: {publication_date: {order: :desc}},
        query: {
          multi_match: {
            query: query,
            type: :phrase,
            fields: [:title, :description]
          },
        }
      }

      __elasticsearch__.search(search_definition)
    end
  end
end
