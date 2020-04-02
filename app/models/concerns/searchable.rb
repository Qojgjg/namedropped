module Searchable
  extend ActiveSupport::Concern
  SEARCHABLE_FIELDS = [:title, :description]
  RESULT_SET_SIZE = 100

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
        sort: { publication_date: { order: :desc } },
        query: {
          multi_match: {
            query: query,
            type: :phrase,
            fields: SEARCHABLE_FIELDS
          },
        }
      }

      __elasticsearch__.search(search_definition)
    end

    def self.main_search(query)
      search_definition =  {
        size: RESULT_SET_SIZE,
        sort: { publication_date: { order: :desc } },
        query: {
          multi_match: {
            query: query,
            type: :phrase,
            fields: SEARCHABLE_FIELDS
          },
        }
      }

      __elasticsearch__.search(search_definition)
    end

    def self.crawler_search(query, date)
      search_definition =  {
        size: RESULT_SET_SIZE,
        query: {
          bool: {
            must: {
              multi_match: {
                query: query,
                type: :phrase,
                fields: SEARCHABLE_FIELDS
              }
            },
            must_not: {
              range: { publication_date: { lt: date } }
            }
          }
        }
      }

      __elasticsearch__.search(search_definition)
    end
  end
end
