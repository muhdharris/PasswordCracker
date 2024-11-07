require 'benchmark'

# Define character sets
DEFAULT_CHARSET = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

# Method to perform a dictionary attack
def dictionary_attack(target_password, password_file)
  File.foreach(password_file) do |line|
    attempt_password = line.strip # Remove any whitespace or newline
    puts "Trying password: #{attempt_password}" # Display each attempt (optional)

    if attempt_password == target_password
      puts "Password found with dictionary: #{attempt_password}"
      return attempt_password
    end
  end
  nil
end

# Method to perform brute-force attack
def brute_force_attack(target_password, charset, max_length)
  (1..max_length).each do |length|
    charset.repeated_permutation(length).each do |attempt|
      attempt_password = attempt.join
      puts "Trying password: #{attempt_password}" # Display each attempt (optional)

      if attempt_password == target_password
        puts "Password found with brute-force: #{attempt_password}"
        return attempt_password
      end
    end
  end
  nil
end

# Main method to perform hybrid attack
def hybrid_password_cracker(target_password, password_file = nil, charset = DEFAULT_CHARSET, max_length = 4)
  puts "Starting password cracking for: #{target_password}"

  found_password = nil

  time_taken = Benchmark.realtime do
    # Try dictionary attack first, if a file is provided
    if password_file
      puts "Attempting dictionary attack with file: #{password_file}"
      found_password = dictionary_attack(target_password, password_file)
    end

    # If the password wasn't found in the dictionary, proceed with brute-force
    if found_password.nil?
      puts "Attempting brute-force attack..."
      found_password = brute_force_attack(target_password, charset, max_length)
    end
  end

  if found_password
    puts "Password successfully cracked: #{found_password}"
    puts "Time taken: #{time_taken.round(2)} seconds"
  else
    puts "Password could not be cracked within the provided parameters."
  end
end

# User inputs
puts "Enter the target password:"
target_password = gets.chomp

puts "Enter the path to your password file (leave blank to skip dictionary attack):"
password_file = gets.chomp
password_file = password_file.empty? ? nil : password_file

puts "Enter maximum brute-force password length (default is 4):"
max_length = gets.chomp.to_i
max_length = max_length > 0 ? max_length : 4

puts "Starting the hybrid password cracker..."
hybrid_password_cracker(target_password, password_file, DEFAULT_CHARSET, max_length)
