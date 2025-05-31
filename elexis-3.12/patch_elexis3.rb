#!/usr/bin/env ruby
ini_file = './target/products/ElexisAllOpenSourceApp/linux/gtk/x86_64/Elexis3.ini'
lines = IO.readlines(ini_file)
lines.delete_if { |line| line.match(/\-vm$|justj/) }
File.open(ini_file + '_new', 'w+') { |f| f.puts lines.join}
