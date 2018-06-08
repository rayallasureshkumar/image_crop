class ProjectAssetsController < ApplicationController

	def new
		@project_asset = ProjectAsset.new
	end

	def create
		@project_asset = ProjectAsset.new(params[:project_asset])
		if @project_asset.save
			redirect_to project_assets_url
		else
			render "new"
		end
	end

	def index
		@project_assets = ProjectAsset.all
	end

	def crop
    	@project_asset = ProjectAsset.find(params[:id])
  	end

  	def update
	    @project_asset = ProjectAsset.find(params[:id])
	    @project_asset.crop_x = params[:user]["crop_x"]
	    @project_asset.crop_y = params[:user]["crop_y"]
	    @project_asset.crop_h = params[:user]["crop_h"]
	    @project_asset.crop_w = params[:user]["crop_w"]
	    db   = Mongo::Connection.new.db('image_crop_development')
	    img ||= MiniMagick::Image.read(Mongo::GridFileSystem.new(db).open(@project_asset.attachment.url(:large), 'r'))
	    crop_params = "#{@project_asset.crop_w}x#{@project_asset.crop_h}+#{@project_asset.crop_x}+#{@project_asset.crop_y}"
	    img.crop(crop_params)
	    img.write("/home/raman/test.jpeg")
	    @project_asset.attachment.recreate_versions!
	    @project_asset.attachment = File.open '/home/raman/test.jpeg'
	    @project_asset.save
	    File.delete '/home/raman/test.jpeg'
	    redirect_to project_assets_url
  	end

end
