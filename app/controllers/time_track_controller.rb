class TimeTrackController < ApplicationController
  def new
    @time_track = TimeTrack.new
  end

  def create
    @time_track = TimeTrack.new(time_track_params)
    if @time_track.save
      redirect_to index_path, notice: 'タスクの時間を記録しました'
    else
      render 'new'
    end
  end


  def start
    @task = Task.find(params[:task_id])
    @task_track = @task.task_tracks.build(start_time: Time.current)
    @task_track.save
    redirect_to root_path, notice: 'タスクの作業を開始しました。'
  end

  def stop
    @task = Task.find(params[:task_id])
    @task_track = @task.task_tracks.last
    @task_track.update(end_time: Time.current)
    redirect_to root_path, notice: 'タスクの作業を終了しました。'
  end



  private
  def time_track_params
    params.require(:time_track).permit(:start_time, :end_time, :task_id)
  end
end
