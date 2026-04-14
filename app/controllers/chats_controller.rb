class ChatsController < ApplicationController
  def new
    @chat = Chat.new
  end
end
