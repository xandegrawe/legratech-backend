class Role < ApplicationRecord
  belongs_to :person, polymorphic: true
end
