class Stream < ApplicationRecord

    has_many :stream_infos

    def update_infos
        infos = $hub.stream(name).history_activity()
        infos.each do |info|
            info['start_time'] = info.delete("start")
            info['end_time']   = info.delete("end")
            info['client_iP']  = info.delete("clientIP")
            info['server_iP']  = info.delete("serverIP")
            info['live_name']  = live_name
            info['stream_id']  = id
            StreamInfo.find_or_create_by(info)
        end  if infos.present?  
    end

    def sync_push_pull
        push_url = Pili.rtmp_publish_url("pili-publish.sdqy.bidlive.com.cn", $hub_name, name, $mac, 3600)
        pull_url = Pili.rtmp_play_url("pili-live-rtmp.sdqy.bidlive.com.cn", $hub_name, name)
        update(:push_url => push_url, :pull_url => pull_url)
    end
    # 保存直播文件
    def save_mp4
        info = stream_infos.last
        fname, persistentID= $hub.stream(name).saveas({:fname => live_name, :start => info.start_time, :end => info.end_time, :format => "mp4"})
        info.update(fname: fname, persistentID: persistentID)
    end

    def initialize_data
        titles, marker = $hub.list(:prefix=>'qingyun')
        titles.each do |title|
            stream = $hub.stream(title)
            push_url = Pili.rtmp_publish_url("pili-publish.sdqy.bidlive.com.cn", $hub_name, title, $mac, 3600)
            pull_url = Pili.rtmp_play_url("pili-live-rtmp.sdqy.bidlive.com.cn", $hub_name, title)
            Stream.create(name: title, push_url: push_url, pull_url: pull_url)
        end

    end

    def demo
        title_a = stream_title_prefix + "-a"
        begin
        stream_a = hub.stream title_a
        stream_a.info
        rescue Pili::ResourceNotExist => e
        puts e
        end

        puts "创建流."
        stream_a = hub.create(title_a)
        puts stream_a.info

        puts "获得流."
        stream_a = hub.stream(title_a)
        puts "to_json: #{stream_a.info.to_json}"

        puts "创建重复的流."
        begin
        hub.create(title_a)
        rescue Pili::ResourceConflict => e
        puts e
        end

        puts "创建另一路流."
        title_b = stream_title_prefix + "-b"
        stream_b = hub.create(title_b)
        puts stream_b.info

        puts "列出所有流."
        begin
        titles, marker = hub.list(:prefix=>stream_title_prefix)
        puts titles.to_s, marker
        rescue Pili::ResourceNotExist => e
        puts e
        end

        puts "列出正在直播的流."
        begin
        titles, marker = hub.list_live(:prefix=>stream_title_prefix)
        puts titles.to_s, marker
        rescue Pili::ResourceNotExist => e
        puts e
        end

        puts "批量查询直播信息."
        live_statuses = hub.batch_query_live_status([title_a, title_b])
        puts live_statuses

        puts "禁用流."
        stream_a.disable()
        puts stream_a.info

        puts "启用流."
        stream_a.enable()
        puts stream_a.info

        puts "禁用流 10 秒"
        begin
        puts("before disable: #{stream_a.info.to_json}")
        stream_a.disable_till(Time.now.to_i + 10)
        puts("after disable: #{stream_a.info.to_json}")
        sleep(10)
        puts("after 10 seconds: #{stream_a.info.to_json}")
        rescue Pili::ResourceNotExist => e
        puts e
        end

        puts "查询直播状态."
        begin
        status = stream_a.live_status()
        puts status
        rescue Pili::ResourceNotExist => e
        puts e
        end

        puts "更改流的实时转码规格"
        begin
        puts stream_a.info.to_json
        stream_a.update_converts(["720p", "480p"])
        puts stream_a.info.to_json
        rescue => e
        puts e
        end

        puts "查询推流历史."
        activity = stream_a.history_activity()
        puts activity

        puts "保存直播数据."
        begin
        fname, persistentID = stream_a.saveas(:format => "mp4")
        puts fname, persistentID
        rescue => e
        puts e
        end

        puts "保存直播截图."
        begin
        fname = stream_a.snapshot()
        puts(fname)
        rescue => e
        puts e
        end

        puts "RTMP 推流地址."
        url = Pili.rtmp_publish_url("publish-rtmp.test.com", hub_name, title_a, mac, 3600)
        puts url

        puts "RTMP 直播放址."
        url = Pili.rtmp_play_url("live-rtmp.test.com", hub_name, title_a)
        puts url

        puts "HLS 直播地址."
        url = Pili.hls_play_url("live-hls.test.com", hub_name, title_a)
        puts url

        puts "HDL 直播地址."
        url = Pili.hdl_play_url("live-hdl.test.com", hub_name, title_a)
        puts url

        puts "截图直播地址"
        url = Pili.snapshot_play_url("live-snapshot.test.com", hub_name, title_a)
        puts url
    end

end
