class Api::V1::TrailsController < ApplicationController
    before_action :find_trail, only:[:show, :update, :destroy]

    def index
        @trails = Trail.all
        render json: @trails
    end

    def show
        render json: @trail
    end

    def create
        @trail = Trail.new(trail_params)
        if @trail.save
            render json: @trail
        else
            render error: { error: 'Unable to create trail.'}, status: 400
        end
    end

    def update
        if @trail
            @trail.update(trail_params)
            render json: { message: 'Trail succesfully updated.' }, status: 200
        else
            render json: { error: 'Unable to update trail.'}, status: 400
        end
    end

    def destroy
        if @trail
            @trail.destroy
            render json: { message: 'Trail succesfully deleted.' }, status: 200
        else
            render json: { error: 'Unable to delete trail.'}, status: 400
        end
    end

    private

    def trail_params
        params.require(:trail).permit(:trail, :lat, :lon, :user_id)
    end

    def find_trail
        @trail = Trail.find(params[:id])
    end
        
end