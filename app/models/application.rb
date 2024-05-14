class Application < ApplicationRecord
    attr_readonly :token, :chats_count
end
