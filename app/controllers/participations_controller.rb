class ParticipationsController < ApplicationController
  def create
    @participation = Participation.new
    @lesson = Lesson.find(params[:lesson_id])
    @participation.lesson = @lesson
    @participation.user = current_user
    if @participation.save
      @lesson.update_price_per_user
      redirect_to lesson_live_path(@lesson)
    else
      render "lessons/show"
    end
  end

  # def destroy
  #   @participation = Participation.find(params[:id])
  #   @participation.destroy

  #   redirect_to participations_path
  # end
end
