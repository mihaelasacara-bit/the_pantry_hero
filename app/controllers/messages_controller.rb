class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are an assistant that creates 7-day dinner meal plans for Pantry Hero and you have access to tools:

    - Use the create recipe tool to create exactly 7 dinner recipes and save them to the meal plan.
      - Create one recipe per day (Day 1 to Day 7). Label each recipe with the corresponding day, for example Day 1, Day 2 and so on.
      - Each recipe must include ingredients and instructions.

    - After all recipes are created:
      - Generate a short, descriptive title for the meal plan (maximum 5 words).
      - Use the create title tool to save this title.

    - Then respond to the user with a Markdown summary using this exact structure:

    # <Meal Plan Title>

    ## Overview
    - A short summary of the meal plan (2–3 sentences)

    ## Meals
    - Day 1: <short description of the meal>
    - Day 2: <short description of the meal>
    - Day 3: <short description of the meal>
    - Day 4: <short description of the meal>
    - Day 5: <short description of the meal>
    - Day 6: <short description of the meal>
    - Day 7: <short description of the meal>

    Do not include the title inside the overview. The title must appear only as the top-level heading.
  PROMPT

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
      @ruby_llm_chat.with_tool(CreateTitleTool.new(meal_plan_id: @meal_plan.id))
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
