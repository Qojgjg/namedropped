class Episode < ApplicationRecord
  include Searchable

  belongs_to :podcast
  validates :guid, uniqueness: { scope: :podcast, message: 'The GUID has to be unique for each podcast' }
end
