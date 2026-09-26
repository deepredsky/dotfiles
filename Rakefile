require 'rake'
require 'erb'
require 'fileutils'

DOTFILES_DIR = File.expand_path(__dir__)
HOME = ENV.fetch('HOME')
BACKUP_DIR = File.join(HOME, '.dotfiles_backup', Time.now.strftime('%Y%m%d%H%M%S'))

SKIP = %w[Rakefile README.md LICENSE Brewfile config nix]

desc "install the dot files into user's home directory"
task :install do
  ensure_fish_shell
  replace_all = false

  (Dir['*'] - SKIP).each do |file|
    target = File.join(HOME, ".#{file.sub(/\.erb$/, '')}")

    if up_to_date?(file, target)
      puts "identical #{target}"
      next
    end

    if File.exist?(target) || File.symlink?(target)
      if replace_all
        install_file(file, target)
      else
        print "overwrite #{target}? [ynaq] "
        case $stdin.gets.chomp
        when 'a' then replace_all = true; install_file(file, target)
        when 'y' then install_file(file, target)
        when 'q' then exit
        else puts "skipping #{target}"
        end
      end
    else
      install_file(file, target)
    end
  end
end

def up_to_date?(file, target)
  return false unless File.exist?(target) || File.symlink?(target)

  if file =~ /\.erb$/
    !File.symlink?(target) && File.exist?(target) && File.read(target) == render_erb(file)
  else
    File.symlink?(target) && File.readlink(target) == File.join(DOTFILES_DIR, file)
  end
end

def install_file(file, target)
  if File.exist?(target) || File.symlink?(target)
    FileUtils.mkdir_p(BACKUP_DIR)
    FileUtils.mv(target, File.join(BACKUP_DIR, File.basename(target)))
    puts "backed up #{target} -> #{BACKUP_DIR}"
  end

  if file =~ /\.erb$/
    puts "generating #{target}"
    File.write(target, render_erb(file))
  else
    puts "linking #{target}"
    File.symlink(File.join(DOTFILES_DIR, file), target)
  end
end

def render_erb(file)
  ERB.new(File.read(file)).result(binding)
end

def ensure_fish_shell
  fish = `which fish`.strip

  if fish.empty?
    puts "fish not found (install it via Brewfile on macOS or programs.fish on NixOS, then re-run)"
    return
  end

  if ENV['SHELL'] == fish
    puts "using fish"
    return
  end

  print "switch default shell to fish (#{fish})? [ynq] "
  case $stdin.gets.chomp
  when 'y' then system(%Q{chsh -s "#{fish}"})
  when 'q' then exit
  else puts "skipping shell switch"
  end
end
