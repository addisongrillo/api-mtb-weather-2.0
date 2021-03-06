require 'date'

class Api::V1::TrailsController < ApplicationController
    before_action :find_trail, only:[:show, :update, :destroy, :history]

    def index
        subtract= Trail.where("user_id =?", @current_user.id).order(:order).first.order-1
        if subtract > 0
            Trail.where("user_id =?", @current_user.id).map{|t| t.increment!(:order, subtract * -1)}
        end
        data={}
        @trails = Trail.all.where("user_id =?", @current_user.id).order(:order)
        data=[]
        @trails.each  do |t|
             data.push({
                    trail:t,
                    weather:t.weather
             })
         end

        render json: data
        
    end

    def show
            render json:
        {
            trail:@trail,
            weather:@trail.weather
        }
        
    end

    def history
           render json:
       {
           trail:@trail,
           weather_y:@trail.weather_yesterday,
           weather_t: @trail.weather_all_day
       }
       
   end

    def create
        @trail = Trail.new(trail_params)
        @trail.user_id=@current_user.id
        @trail.order=1
        if @trail.save
            Trail.where("user_id =?", @current_user.id).where("id <>?", @trail.id ).map{|t| t.increment!(:order)}
            render json: @trail
        else
            render error: { error: 'Unable to create trail.'}, status: 400
        end
    end

    def update
        if @trail.user_id==@current_user.id
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
    def changeOrder
            params[:trail][:order].each_with_index do |o, i|
            @trail = Trail.where("id=?",o).where("user_id=?",@current_user.id).first
            @trail.order=i+1
            @trail.save
            end
            render json: { message: 'Order Updated.'}, status: 200
    end

    private

    def trail_params
        params.permit(:name, :lat, :lon, :order, :user_id)
    end

    def find_trail
        @trail = Trail.where("id=?",params[:id]).where("user_id=?",@current_user.id).first
    end

    def format_weather(w)
        w["current"]["dt"]=Time.at(w["current"]["dt"]+w["timezone_offset"]).in_time_zone('UTC').strftime("%I:%M %p")
            w["current"]["sunrise"]=Time.at(w["current"]["sunrise"]+w["timezone_offset"]).in_time_zone('UTC').strftime("%I:%M %p")
            w["current"]["sunset"]=Time.at(w["current"]["sunset"]+w["timezone_offset"]).in_time_zone('UTC').strftime("%I:%M %p")
            w["hourly"].select do |h|
                h["dt"]=Time.at(h["dt"]+w["timezone_offset"]).in_time_zone('UTC').strftime("%I:%M %p") 
            end
    end
        
end