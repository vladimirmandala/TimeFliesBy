class TasksController < ApplicationController
  before_filter :authenticate_user!

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks.all :include => :tags

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = current_user.tasks.new
    @tags = current_user.tags.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = current_user.tasks.find(params[:id])
    @tags = current_user.tags.all
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.new(params[:task])
    @task.switch_now if params[:commit] == 'Switch Now'

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        @tags = current_user.tags.all
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = current_user.tasks.find(params[:id])
    if params[:commit] == 'Switch Now'
      @task.switch_now
      params[:task] ||= {}
      params[:task][:stop] = @task.stop
    end

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :ok }
      else
        @tags = current_user.tags.all
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :ok }
    end
  end

  # POST /tasks/1
  # POST /tasks/1.json
  def switch_to
    task = current_user.tasks.find(params[:id]).switch_to

    respond_to do |format|
      if task.save
        format.html { redirect_to tasks_url, notice: 'Task was successfully switched back to again.' }
        format.json { render json: task, status: :created, location: task }
      else
        format.html { redirect_to tasks_url, notice: 'Error! Please try again...' }
        format.json { render json: task.errors, status: :unprocessable_entity }
      end
    end
  end
end
