require "erb"
require "json"
require "yaml"
require "date"
require "digest"

class Finances < Sinatra::Base
  set :server, :puma
  set :port, ENV["PORT"]
  set :root, File.expand_path("..", File.dirname(__FILE__))
  set :bind, "0.0.0.0"

  register Sinatra::Reloader

  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    hash = Digest::SHA256.hexdigest password
    username == "admin" && hash == ENV["PASSWORD"]
  end

  def navbar_links
    content = ""
    Dir["data/*.yml"].each do |file|
      file.slice! "data/"
      file.slice! ".yml"
      content += "<li><a href='#{file}'>#{file.capitalize}</a></li>"
    end
    content
  end

  get "/" do
    @content_navbar = navbar_links
    erb :index
  end

  ["/:name", "/:name/:years"].each do |path|
    get path do
      money = 0
      income = 0
      waste = 0
      month = 0
      display_years = params[:years] ? params[:years].to_i : 5
      set_balance = false
      set_month = false
      set_year = false
      this_month = Date.today.strftime("%m")
      this_year = Date.today.strftime("%Y")
      month = this_month.sub!(/^0/, "").to_i
      until_year = this_year.to_i + display_years
      cur_year = this_year.to_i
      months = %w[Januari Februari March April May June Juli August September October November December]
      if File.file?("data/#{params[:name]}.yml")
        config = YAML.load_file("data/#{params[:name]}.yml")
        content = "['Month','Money','Expenses','Income'],"
        while cur_year < until_year
          while month < 12
            config.each do |row|
              amount = 0
              modifier = ""
              row.each do |type, data|
                if type == "balance"
                  money = data
                  set_balance = true
                end unless set_balance
                if type == "month"
                  month = data - 1
                  set_month = true
                end unless set_month
                if type == 'year'
                  year = data-1
                  set_year = true
                end unless set_year
                amount = 0
                period = 0
                growth = 0
                except = 0
                stack = true
                modifier = ""
                debit_month = 0
                debit_year = cur_year
                data.each do |k, v|
                  amount = v if k == "amount"
                  period = v if k == "period"
                  modifier = v if k == "modifier"
                  debit_month = v if k == "month"
                  debit_year = v if k == "year"
                  growth = v if k == "growth"
                  except = v if k == "except"
                  stack = v if k == "stack"
                end unless %w[balance month year].include? type

                if growth > 0
                  offset = cur_year.to_i - this_year.to_i
                  if offset > 0
                    increase = 1 + (growth.to_f / 100)
                    (1..offset).each do
                      amount *= increase
                    end
                    amount = amount.round
                  end
                end

                if (period == "monthly") ||
                   (period == "yearly" && month == debit_month - 1) ||
                   (period == "once" && month == debit_month - 1 && cur_year == debit_year)
                  money -= amount if modifier == "minus"
                  money += amount if modifier == "plus"
                  waste += amount if modifier == "minus" unless stack == false
                  income += amount if modifier == "plus" unless stack == false
                end unless (except.to_s.split(",").include? months[month]) ||
                           (except.to_s.split(",").include? "#{cur_year.to_s}") ||
                           (except.to_s.split(",").include? "#{months[month]} #{cur_year.to_s}")
              end
            end
            content += "['#{months[month]} #{cur_year}', #{money}, #{waste}, #{income}],"
            month += 1
          end
          cur_year += 1
          month = 0
        end
        content = content.chomp(",")
        @content_navbar = navbar_links
        @content = content
        erb :data
      else
        status 404
        @message = "Unable to locate this profile."
        erb :index
      end
    end
  end
end
