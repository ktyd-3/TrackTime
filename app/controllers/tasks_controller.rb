class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :asc)
    @today_tasks = Task.where("DATE(created_at) = ?", Date.today).order(created_at: :asc)
    #まだcompleteが更新されていないタスク
    @current_task = Task.find_by(complete: 0,start_time: nil)

    @next_task = Task.where("id > ? AND complete = ?", @current_task.id, 0).first if @current_task.present?
    @tasks_by_hour = Task.group("DATE_TRUNC('hour', start_time)").sum("EXTRACT(epoch FROM (end_time - start_time)) / 3600")
  end

  def new
    @task = Task.new
  end

  def start
    @task = Task.find(params[:id])
    @task.update(start_time: Time.current)
    redirect_to track_tasks_path, notice: 'タスクの作業を開始しました。'
  end

  def stop
    @task = Task.find(params[:id])
    @task.update(end_time: Time.current)
    redirect_to track_tasks_path, notice: 'タスクの作業を終了しました。'
  end

  def track
    @today_tasks = Task.where("DATE(created_at) = ?", Date.today)
    @task_data = @today_tasks.map do |task|
      if task.start_time.present? && task.end_time.present?
        [task.name, (task.end_time - task.start_time)]
      else
        [task.name, 0]  # 合計時間をゼロとする
      end
    end
  end

  def next
    @task = Task.find(params[:id])
    @task.update(complete: 1)
    @tasks = Task.all.order(created_at: :asc)
    redirect_to tasks_path, notice: 'タスクを完了しました'
  end

  def destroy_all
    Task.destroy_all
    flash.now[:notice] = 'すべてのタスクを削除しました'
    redirect_to tasks_path
  end


  def create
    task_params = params.require(:task).permit(name: [])
    task_params[:name].each do |name|
      Task.create(name: name)
    end
      redirect_to tasks_path, notice: '登録が完了しました'
  end


  private
  def task_params
    params.require(:task).permit(:name, :rest)
  end
end
