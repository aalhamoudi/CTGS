class Errors
    
    ERRORS_PATH = "../Middletier/errors.json"
    
    def self.get
        JSONConfig.get(ERRORS_PATH) 
    end
    
end