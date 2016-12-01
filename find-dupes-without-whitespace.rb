require 'digest/sha1'

class DupFinder
  def initialize
    @files={}
  end

  def normalize content
    content.gsub(/\s/, '')
  end

  def look path
    return unless File.file?(path)
    normalized_content = normalize(open(path).read)
    sha1 = Digest::SHA1.hexdigest(normalized_content)
    @files[sha1] ||= []
    @files[sha1] << path
  end

  def summary
    @files.each_pair.select{|k, v|
      v.length > 1
    }.map{|k, v| v}
  end
end

finder = DupFinder.new

ARGV.each{|file|
  finder.look file
}

finder.summary.each{|pairs|
  puts pairs.join("\n")
  puts
}
