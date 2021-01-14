class LiveListsController < ApplicationController

    before_action :set_stream, only: [:sync_push_pull, :sync_info, :show, :edit, :update]

    def index
        @streams = Stream.order('id desc').page(params[:page]).per(20)
    end

    def sync_push_pull
        @stream.sync_push_pull
        redirect_to action: :index
    end

    def sync_info
        @stream.update_infos
        gon.msg = '成功刷新直播记录,请查看!'
        redirect_to action: "index"
    end

    def edit
    end

    def update
        @stream.update(params.require("stream").permit(:live_name, :start_time, :end_time))
        redirect_to action: :index
    end

    def show
        @stream_infos = @stream.stream_infos.order('id desc').page(params[:page]).per(30)
    end

    def save_mpfour
        @stream.save_mp4
        redirect_to action: :index
    end

    def live_show
        
    end

    private
    def set_stream
        @stream = Stream.find_by(id: params["id"])
    end

end