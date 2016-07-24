require 'fileutils'

def operate_file(file)
  operation_num = 0
  dirname = File.join(File.dirname(file.path), 'new')
  Dir.mkdir(dirname) unless Dir.exist?(dirname)
  filename = File.basename(file.path)
  File.open(File.join(dirname, filename), 'w') do |f|
    file.each_line do |line|
      if /-{3}\n/.match(line)
        operation_num += 1
        if operation_num == 2
          f << <<-EOB
description: ''
main-class: 'dev'
color: '#2DA0C3'
introduction: ''
EOB

        end
      end
      f << line
    end
  end
end

FileUtils.cd('_posts/default/') do
  dir = Dir.new(FileUtils.pwd)
  dir.each do |file|
    if /.+?\.md$/.match(file)
      filepath = File.join(dir.path, file)
      File.open(filepath) do |f|
        operate_file(f)
      end
    end
  end
end
