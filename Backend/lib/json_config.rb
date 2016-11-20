class JSONConfig
    # This class is responsible for retrieving JSON contents from a
    # file on live basic (each time its sole method, get, is called,
    # new contents will be retrieved REGARLESS of what was previously
    # retrieved.)

    # "Read class' description."
    def self.get(path, contents=nil)
        contents = [] if contents.nil?
        begin
        	to_parse = open path, "r" do |io| io.read end
        rescue Errno::ENOENT => e
        	puts e
        end
        parsed = JSON.parse to_parse
        if parsed
        	parsed.each do |c|
        		contents.push c
        	end
        end 
    end
    
end