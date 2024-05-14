class Application < ApplicationRecord
    attr_readonly :token
    has_many :chats
end
