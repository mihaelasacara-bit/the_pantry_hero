class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are an assitant for meal plans."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @meal_plan = @chat.meal_plan

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat.with_temperature(0.8)
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
