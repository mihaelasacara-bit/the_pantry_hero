class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are an assitant that creates meal plans with 7 dinner recipes. / Tools: Use the create recipe tool to create the recipes and save them to the meal plan, one recipe per day. Include ingredients and instructions. After you create the plan, share a short summary in Markdown with the user."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @meal_plan = @chat.meal_plan

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @assistant_message = @chat.messages.create(role: "assistant", content: "")

      response = ask_llm
      @assistant_message.update(content: response.content)
      broadcast_replace(@assistant_message)

      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to chat_path(@chat) }
      end
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(message)
    end
  end

  def ask_llm
    @ruby_llm_chat = RubyLLM.chat(model: 'gpt-4o-mini')
    build_conversation_history

    @ruby_llm_chat.with_tool(CreateRecipeTool.new(user: current_user, meal_plan_id: @meal_plan.id))
    @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

    @ruby_llm_chat.ask(@message.content) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(@chat, target: helpers.dom_id(message), partial: "messages/message",
                                                      locals: { message: message })
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
