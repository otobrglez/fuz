# By Oto Brglez - <oto.brglez@opalab.com>

guard 'spork' do
	watch('spec/spec_helper.rb')
end

guard 'rspec', :version => 2, :cli => "--color --drb", :all_on_start => false, :all_after_pass => false  do

	watch(%r{^spec/.+_spec\.rb$})
	watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
	watch('spec/spec_helper.rb')  { "spec" }
	
end