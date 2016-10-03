require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  install_fish
  switch_to_fish
  replace_all = false
  files = Dir['*'] - %w[Rakefile README.rdoc LICENSE]
  files.each do |file|
    system %Q{mkdir -p "$HOME/.#{File.dirname(file)}"} if file =~ /\//
    if File.exist?(File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}")
        puts "identical ~/.#{file.sub(/\.erb$/, '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub(/\.erb$/, '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub(/\.erb$/, '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub(/\.erb$/, '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub(/\.erb$/, '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  elsif file =~ /config\.fish$/
    #~/.config/fish/config.fish
    puts "copying ~/.config/fish/#{file}"
    system %Q{mkdir -p ~/.config/fish}
    system %Q{cp "$PWD/#{file}" "$HOME/.config/fish/#{file}"}
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def switch_to_fish
  if ENV["SHELL"] =~ /fish/
    puts "using fish"
  else
    print "switch to fish? (recommended) [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "switching to fish"
      system %Q{chsh -s `which fish`}
    when 'q'
      exit
    else
      puts "skipping fish"
    end
  end
end

def install_fish
  puts "installing fish"
  system %Q{brew install fish}
end
