# Helper pour la lecture de fichier 
class FileHelper

    attr_accessor :file

    def initialize
        puts "INITIALISE FILE HELPER"
    end

    def open_file(file_path = nil)
        file_name = file_path ? file_path : "./dictionary.text"
        
        if File.file?(file_name)
             # p "Fichier trouvé"
            @file = File.open(file_name)
        else
            # p "Fichier non trouvé"
            return false
        end
    end

    def file_readlines
        file_data = @file.readlines.map(&:chomp)
    end

    def close_file
        @file.close
    end

    def get_file_data(file_path = nil)
        open_file(file_path)
        data = file_readlines
        close_file

        return data
    end
end
