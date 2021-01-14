class StreamInfo < ApplicationRecord

    belongs_to :stream

    def end_time_str
        Time.at(end_time).strftime("%Y-%m-%d %H:%M:%S")
    end

    def start_time_str
        Time.at(start_time).strftime("%Y-%m-%d %H:%M:%S")
    end

end
