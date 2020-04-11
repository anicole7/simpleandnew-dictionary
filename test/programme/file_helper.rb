# Helper pour la lecture de fichier 
class FileHelper

    attr_accessor :file

    def open_file(file_path = nil)
        @file = File.open(file_path ? file_path : "dictionary.text")
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
