require 'securerandom'

class Post < Sequel::Model

  unrestrict_primary_key

  class << self
    def create(data)
      data[:id] = SecureRandom.uuid
      super
    end
  end
end
