Elasticsearch::Model.client = Elasticsearch::Client.new(
  url:
  case Rails.env
  when "production"
    ENV['ELASTICSEARCH_URL']
  when "test"
    'http://localhost:9250'
  else
    'http://localhost:9200'
  end
)
