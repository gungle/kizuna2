class AccessesController < ApplicationController
  # GET /accesses
  # GET /accesses.xml
  def index
    @accesses = Access.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accesses }
    end
  end

  # GET /accesses/1
  # GET /accesses/1.xml
  def show
    @access = Access.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @access }
    end
  end

  # GET /accesses/new
  # GET /accesses/new.xml
  def new
    @access = Access.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @access }
    end
  end

  # GET /accesses/1/edit
  def edit
    @access = Access.find(params[:id])
  end

  # POST /accesses
  # POST /accesses.xml
  def create
    @access = Access.new(params[:access])

    respond_to do |format|
      if @access.save
        flash[:notice] = 'Access was successfully created.'
        format.html { redirect_to(@access) }
        format.xml  { render :xml => @access, :status => :created, :location => @access }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @access.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accesses/1
  # PUT /accesses/1.xml
  def update
    @access = Access.find(params[:id])

    respond_to do |format|
      if @access.update_attributes(params[:access])
        flash[:notice] = 'Access was successfully updated.'
#        format.html { redirect_to(@access) }
        format.html { redirect_to(:controller => :logins, :action => :top) }

        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @access.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accesses/1
  # DELETE /accesses/1.xml
  def destroy
    @access = Access.find(params[:id])
    @access.destroy

    respond_to do |format|
      format.html { redirect_to(accesses_url) }
      format.xml  { head :ok }
    end
  end
end
