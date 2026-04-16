class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are an assitant that creates meal plans with 7 dinner recipes. / Tools: Use the create recipe tool to create the recipes and save them to the meal plan, one recipe per day. Include ingredients and instructions. After you create the plan, share a summary with the user."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @meal_plan = @chat.meal_plan

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat.with_temperature(0.8)
      build_conversation_history
      @ruby_llm_chat.with_tool(CreateRecipeTool.new(user: current_user, meal_plan_id: @meal_plan.id))
      response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      @assistant_message = Message.create(role: "assistant", content: response.content, chat: @chat)

      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to chat_path(@chat) }
      end
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
