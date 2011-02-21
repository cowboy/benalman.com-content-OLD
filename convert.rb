require 'fileutils'
require 'yaml'
require 'awesome_print'
require 'net/http'
require 'cgi'
require './util'

$files_in = "mt-export/"
$files_out = "new/"
$images = "images/"

if !Dir.exist?($files_in)
  puts "Error: #{$files_in} not found!"
  exit
end

# Build entries.
$entries = {}
Dir.entries($files_in).each do |dir|
  path = "#{$files_in}/#{dir}"
  if FileTest.directory?(path) && !File.basename(path).start_with?('.')
    docs = []
    YAML.each_document(IO.read("#{path}/index.md")) {|doc| docs << doc} rescue nil
    raise StandardError, "Invalid data in #{path}" if docs.length != 2
    $entries[dir] = ConfigObj.new({path: dir, meta: docs[0], content: docs[1], files: []})
  end
end

# Rename gyazo-grabbed images.
$img_map = {
  "e09f87" => "tweet",
  "1a2e9a" => "barry",
  "2184f5" => "before",
  "4c4fc9" => "after",
  "75ed58" => "win",
  "408ebe" => "resig-norris",
  "b7e79c" => "meow",
  "7a969f" => "preparation",
  "921c76" => "launch",
  "f52855" => "profilemanager",
  "ed0d7d" => "profile",
  "35e0a6" => "launch",
  "d2dff6" => "success"
}

# Do metadata tweaking here.
$meta_map = YAML.load_file('meta_map.yaml')

temp = {}

def img_src_file(src)
  src = "http://benalman.com#{src}" if src.start_with? '/'
  #puts src
  src.sub!(%r{.*/}, '')
  file = if src =~ /([a-f0-9]{6})(\.png)/ && $img_map[$1]
    "#{$img_map[$1]}#{$2}"
  else
    src
  end
  [src, file]
end

# Iterate over entries.
$entries.each do |path, e|
  m, mm = e.meta, $meta_map[path]
  #puts "\n=== #{path} ==="

  # Sort categories so that primary category is first.
  m.categories.unshift m._primary_category
  m.categories.uniq!
  m.to_hash.delete(:_primary_category)

  # Remove misc unnecessary metadata.
  m.to_hash.delete(:_allow_comments)
  m.to_hash.delete(:_allow_pings)
  m.to_hash.delete(:_published)

  # Flag that can be set to false to not publish this article.
  e.publish = !m.tags.index('@hidden')
  next unless e.publish

  # Array of image names.
  e.image_names = []

  # Build array of included files.
  e.incl_names = []
  e.incl_contents = []
  i = 0
  e.content.gsub!(%r{<pre(\b[^>]*)>(.*?)</pre>}m) do |match|
    e.incl_contents << CGI::unescapeHTML($2.unindent.strip)
    ext = $1[/\bbrush:(\w+)\b/, 1]
    name = mm['incl_names'][i] #"file#{i}.#{ext}"
    e.incl_names << name
    i += 1
    "{{ #{name} }}"
  end

  # Get non-date path and yyyy/mm date from original path.
  path, date = path.sub(/^(\d{4})-(\d{2})-\d{2}-/, ''), "#{$1}/#{$2}"

  # Category-specific tweaks.
  if m.categories.first =~ /^(?:Projects|Music$)/
    m.title, m.subtitle = m.title.split(/:\s+/)
    #m.path = path
  elsif m.categories.first == 'News' && m.categories.index('Project')
    #m.categories.first ==
  end

  # Original path.
  arr = [m.categories.first.downcase, path]
  arr.insert(1, date) if m.categories.first == 'News'
  e.path_orig = arr.join '/'

  # Gaucho-filterize flickr photos. TODO: implement "flickr" filter in app.
  e.content.gsub!(%r{<div class="photo">(.*?)</div>}m) do |match|
    if $~.to_s.index('flickr').nil?
      $~.to_s
    else
      $1 =~ %r{<a href="(.*?)".*src="(.*?)"}
      link, img = $1, $2
      link.gsub!(%r{^http://benalman.com/photo/|/$}, '')
      link.sub!(%r{/detail$}, '')
      link.sub!(%r{^(taken|posted)-on/}, 'archives/date-\1/')
      link.sub!(%r{/in/(taken|posted)-on-.*$}, '/in/date\1')
      img.sub!('_t.jpg', '.jpg')
      "{{ #{img} | flickr(#{link}) }}"
    end
  end

  # Remove any inline forms (simplified: paypal donate).
  e.content.gsub!(%r{<form.*?</form>}mi, '')

  # Remove <div class="photo"> wrapper.
  e.content.gsub!(%r{<div class="photo">(.*?)</div>}mi, '\1')

  # Filterize markdown images.
  e.content.gsub!(%r{!\[(.*?)\]\((.*?)\)}) do |match|
    alt, src = $1, $2
    src, file = img_src_file(src)
    e.image_names << [src, file]

    if alt.nil? || alt == ''
      "{{ #{file} }}"
    else
      "{{ #{file} | image(#{alt}) }}"
    end
  end

  # Filterize HTML images.
  e.content.gsub!(%r{<img(\b[^>]*?)/?>}mi) do |match|
    attrs = $1
    arr = attrs.split(/\s+/)
    props = {}
    arr.each do |item|
      item =~ /^(.*?)=(['"])([^\2]*)\2/
      value = Integer($3) rescue $3
      props[$1] = value if $1 && !value.nil? && value != ''
    end
    alt, src = props['alt'], props['src']
    src, file = img_src_file(src)
    e.image_names << [src, file]

    props.delete('border')
    props.delete('style')
    props.delete('alt')
    props.delete('src')

    if !props.empty?
      "{{ #{file} | image(#{props.to_s.gsub(/"([^"]+)"=>/, '\1: ').gsub(/^\{|\}$/, '')}) }}"
    elsif alt.nil? || alt == ''
      "{{ #{file} }}"
    else
      "{{ #{file} | image(#{alt}) }}"
    end
  end

  # Ensure original path is valid.
  if false
    puts "Checking #{e.path_orig}..."
    resp = Net::HTTP.get_response 'benalman.com', "/#{e.path_orig}/"
    raise "Bad URL: #{e.path_orig} (Status: #{resp.code})" if resp.code != '200'
  end

  # Content-specific tweaks.
  if m.title =~ %r{Gig: (.*?) w/ (.*?) @ (.*?) in (.*)}
    m.title = "Gig: #{$2} @ #{$3}"
    loc = $4.index(',') ? $4 : "#{$4}, MA"
    date = $1.sub('Nov', 'November')
    m.subtitle = "#{date} in #{loc}"
  end
end

#ap temp

FileUtils.rm_rf($files_out)

total = actual = 0
$entries.each do |path, e|
  total += 1
  m, mm = e.meta.to_hash, $meta_map[path]
  next if mm.nil? || !mm['publish']

  %w{title subtitle categories}.each do |prop|
    m[prop.to_sym] = mm[prop] if mm[prop]
  end

  %w{path_new incl_names publish}.each do |prop|
    e[prop.to_sym] = mm[prop] if mm[prop]
  end

  if e.publish # && e.incl_names.class == Array && !e.incl_names.empty?
    actual += 1
    puts '======'
    puts path
    metas = %w{title subtitle categories tags date}.map do |key|
      value = m[key.to_sym]
      if value.class == Array
        "#{key}: [#{value.join(', ')}]"
      elsif value =~ /^'|: /
        if value =~ /"/
          "#{key}: '#{value.gsub("'", "\\'")}'"
        else
          "#{key}: \"#{value.gsub('"', '\\"')}\""
        end
      else
        "#{key}: #{value}"
      end
    end
    index = metas.join("\n") + "\n--- |\n" + e.content
    path = "#{$files_out}#{e[:path_new]}"
    FileUtils.mkdir_p(path)
    File.open("#{path}/index.md", 'w') {|f| f.write(index)}
    e.image_names.uniq!
    p [e.incl_names.length, e.incl_contents.length, e.image_names.length]
    e.incl_names.each_index do |i|
      name = e.incl_names[i]
      data = e.incl_contents[i]
      puts name
      File.open("#{path}/#{name}", 'w') {|f| f.write(data)}
    end
    e.image_names.each do |orig_name, new_name|
      FileUtils.cp("#{$images}#{orig_name}", "#{path}/#{new_name}")
      puts new_name
    end
  end
end

puts "\nConverted: #{actual} / #{total} pages"

FileUtils.cd($files_out)
`git init .`
`git add .`
`git commit -m "Initial import of content from old site."`

=begin
def generate_meta
  # generate metadata map
  $map = {}

  # Sort.
  $arr = []
  $entries.each {|e| $arr << e}
  $arr.sort! do |a, b|
    first, second = [
      [b[1].meta.categories[0], a[1].meta.categories[0]],
      [b[1].meta.categories[1], a[1].meta.categories[1]],
      [b[1].content.length, a[1].content.length]
    ].find {|x,y| x != y}
    first <=> second
  end

  # Output only the metadata I care about.
  $arr.each do |path, e|
    m = e.meta
    new_m = {
      'url' => "http://benalman.com/#{e.path_orig}/ (ignored)",
      'path_orig' => m.path_orig,
      'path_new' => m.path || path,
      'title' => m.title,
      'subtitle' => m.subtitle,
      'publish' => m.publish,
      'categories' => m.categories,
    }
    new_m['incl_names'] = e.incl_names unless e.incl_names.empty?

    $map[path] = new_m if m.publish
  end
  YAML::dump($map)
end

#File.open('meta_map2.yaml', 'w') {|f| f.write(generate_meta)}
=end
