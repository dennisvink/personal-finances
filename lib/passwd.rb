require "highline/import"
require "digest"

def get_password(password1 = "foo", password2 = "bar")
  loop do
    password1 = ask("Enter password: ") { |q| q.echo = false }
    password2 = ask("Enter it again: ") { |q| q.echo = false }
    break if password1 == password2
    puts "*** Passwords differ! Try again."
  end
  Digest::SHA256.hexdigest password1
end

password = get_password
File.write("#{File.expand_path("..", File.dirname(__FILE__))}/.env.private", "PASSWORD=#{password}\n")
