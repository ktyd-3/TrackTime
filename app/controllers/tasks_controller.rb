class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :asc)
    #まだcompleteが更新されていないタスクを持ってくる。
    @current_task = Task.find_by(complete: 0)
    if @current_task.present?
      @next_task = Task.where("id > ? AND complete = ?", @current_task.id, 0).first
    end
    @tasks_by_hour = Task.group("DATE_TRUNC('hour', start_time)").sum("EXTRACT(epoch FROM (end_time - start_time)) / 3600")
  end

  def new
    @task = Task.new
  end

  def start
    @task = Task.find(params[:id])
    @task.update(start_time: Time.current)
    redirect_to tasks_path, notice: 'タスクの作業を開始しました。'
  end

  def stop
    @task = Task.find(params[:id])
    @task.update(end_time: Time.current)
    redirect_to tasks_path, notice: 'タスクの作業を終了しました。'
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
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: '登録が完了しました'
    else
      render 'new'
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :rest)
  end
end
