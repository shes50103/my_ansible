require 'byebug'
require 'net/http'

class Attacker
  def initialize
    @url = ENV["url"]
  end

  def perform
    # nginx work better
    `curl --limit-rate 128b #{@url} 2>&1`

    # puma work better
    # `curl --limit-rate 256k #{@url} 2>&1`
  end
end

class Recoder
  def initialize
    @datas = {}
  end

  def start
    start_time = Time.now
    result = yield
    elapsed_time = Time.now - start_time
    @datas["duration"] = elapsed_time
    @datas["time"] = Time.now.to_i

    p "Status: #{@datas["code"]}, Time:#{@datas["duration"]}"
  end
end

class People
  def initialize
    @user_number = ENV["user_number"]
    @sleep_time = ENV["sleep"].to_i
    @pool = []
  end

  def self.start
    new.perform
  end

  def perform
    @user_number.to_i.times do
      @pool << Thread.new do
        attacker = Attacker.new
        recoder = Recoder.new

        loop do
          # sleep( 5 )
          begin
            recoder.start do
              attacker.perform
            end
          rescue Exception => e
            puts "Error: #{e}"
          end
        end
      end
    end

    @pool.each(&:join)
  end
end

People.start

# user_number=200  url=http://127.0.0.1:3000 ruby ~/Desktop/ansible/slow_client_task.rb
# curl --limit-rate 256b http://127.0.0.1:3000
