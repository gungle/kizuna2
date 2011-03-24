class DisastermemosController < ApplicationController
  # GET /disastermemos
  # GET /disastermemos.xml
  def index
    @disastermemos = Disastermemo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @disastermemos }
    end
  end

  # GET /disastermemos/1
  # GET /disastermemos/1.xml
  def show
    
#    @disastermemo = Disastermemo.find(params[:id])
    @disastermemo = Disastermemo.find_by_personal_id(params[:id])
    if @disastermemo.nil?
      @disastermemo = Disastermemo.new
    end
    @disastermemo[:result] = "OK"
    @disastermemo[:message] = ""

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :layout=>false}
#     format.xml  { render :xml => @disastermemo }
    end
  end

  # GET /disastermemos/new
  # GET /disastermemos/new.xml
  def new
    @disastermemo = Disastermemo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @disastermemo }
    end
  end

  # GET /disastermemos/1/edit
  def edit
    @disastermemo = Disastermemo.find(params[:id])
  end

  # POST /disastermemos
  # POST /disastermemos.xml
  def create
    @disastermemo = Disastermemo.new(params[:disastermemo])

    respond_to do |format|
      if @disastermemo.save
        flash[:notice] = 'Disastermemo was successfully created.'
        format.html { redirect_to(@disastermemo) }
        format.xml  { render :xml => @disastermemo, :status => :created, :location => @disastermemo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @disastermemo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /disastermemos/1
  # PUT /disastermemos/1.xml
  def update
    @disastermemo = Disastermemo.find(params[:id])

    respond_to do |format|
      if @disastermemo.update_attributes(params[:disastermemo])
        flash[:notice] = 'Disastermemo was successfully updated.'
        format.html { redirect_to(@disastermemo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @disastermemo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /disastermemos/1
  # DELETE /disastermemos/1.xml
  def destroy
    @disastermemo = Disastermemo.find(params[:id])
    @disastermemo.destroy

    respond_to do |format|
      format.html { redirect_to(disastermemos_url) }
      format.xml  { head :ok }
    end
  end
end
