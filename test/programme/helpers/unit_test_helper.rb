require "./sqlitedb_helper.rb"
require "./file_helper.rb"

class UnitTestHelper

    attr_accessor :file_helper
    attr_accessor :sqlitedb_helper

    def initialize
        puts "INITIALISE UNIT TEST HELPER"
        @file_helper = FileHelper.new
        @sqlitedb_helper = SqlitedbHelper.new
    end

    def test_open_file(file_path = nil)
        begin
            @res = @file_helper.open_file(file_path)
        rescue StandardError => e
            p e.message
        end
        return @res
    end

    def search_words_method_a
    end

    def search_words_method_b
    end



    def insert_word
        @sqlitedb_helper
    end

    def delete_word
    end

end

unitTest = UnitTestHelper.new

p "Did not work, test_open_file("")" if !unitTest.test_open_file("")
p "Did not work, test_open_file('chemin_inexistant')" if !unitTest.test_open_file('chemin_inexistant')
p "Did work, test_open_file('../assets/dictionary.text')" if unitTest.test_open_file("../assets/dictionary.text")
p "Did work, test_open_file()" if unitTest.test_open_file()

p "Fail at test_open_file returns"
p unitTest.file_helper.open_file("")

