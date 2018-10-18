# Parse a picsums file and return a hash(md5sum, [full-path, basename])
def parse_file(file)
  result = Hash.new {|h, k| h[k] = []}
  File.open(file, "r") do |f|
    f.each_line do |line|
      line.chomp!
      full_path, h = line.split("|")

      # if result.has_key?(h)
      #   raise "File #{full_path} has same hash as #{result[h][0][0]}"
      # end
      result[h].push(full_path)
    end
  end
  puts "result size: #{result.size}"
  result
end

#
# @param hash file->md5
def dump_sums(hash, file_to_write)
  File.open(file_to_write, "w") do |f|
    keys = hash.keys.sort
    keys.each do |file|
      f.puts "#{file}|#{hash[file]}"
    end
  end
end

def quote(s)
  "\"#{s}\""
end

mac = parse_file(ARGV[0])
pi = parse_file(ARGV[1])

# Find items in mac that aren't in pi
missing = mac.select do |md5, files|
  !pi.has_key?(md5)
end

# Find items in mac that *are* in pi
matching = mac.select do |md5, files|
  pi.has_key?(md5)
end

missing.each do |md5, files|
  if File.exist?(files[0])
    puts files[0]
  end
#  puts files.to_s
end
puts "Missing: #{missing.size}"
puts "Matching: #{matching.size}"

# matching.each do |md5, files|
#   if files.size > 1
#     raise "too many files in mac: #{files}"
#   end
#   if pi[md5].size > 1
#     raise "too many files in pi: #{pi[md5]}"
#   end
#   puts "mkdir -p #{quote(File.dirname(files[0]))} ; mv #{quote(pi[md5][0])} #{quote(files[0])}"
# end
#

# clean_mac = {}
# files_to_delete = Array.new
# abort = false
# last_ans = nil
# mac.each do |md5, files|
#   if abort
#     files.each do |file|
#       clean_mac[file] = md5
#     end
#   elsif files.size == 1
#     clean_mac[files[0]] = md5
#   else
#     (0...files.size).each do |ind|
#       puts "#{ind}. #{files[ind]}"
#     end
#     if files.size == 2 && files[0] =~ /My Photo Stream/
#       ans = 1
#       puts "Auto-choosing choice 1"
#     else
#       puts "#{files.size}. Abort"
#       print "Choose file to keep [#{last_ans}]: "
#       ans = $stdin.gets.chomp
#       if ans.nil? || ans.empty?
#         ans = last_ans
#       end
#     end
#
#     last_ans = ans = ans.to_i
#
#     if ans == files.size
#       puts "Committing decisions and exiting"
#       abort = true
#       files.each do |file|
#         clean_mac[file] = md5
#       end
#     else
#       (0...files.size).each do |ind|
#         if ind != ans
#           files_to_delete.push(files[ind])
#         end
#       end
#       clean_mac[files[ans]] = md5
#     end
#   end
# end
#
# dump_sums(clean_mac, "clean_mac.txt")
#
# until files_to_delete.empty?
#   chunk = files_to_delete.slice!(0, 20).map {|f| quote(f)}
#   puts "rm #{chunk.join(" ")}"
# end
