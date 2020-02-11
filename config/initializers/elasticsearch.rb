Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: Rails.env.test? ? 'http://localhost:9250' : 'http://localhost:9200',
)
