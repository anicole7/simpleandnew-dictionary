####################################################### TEST BDD
# Dictionnaire(id, langue, label)
# Mot(id, label)

require "sqlite3"

# Open a database
db = SQLite3::Database.new "simpleandnewdictionnary.db"
db.results_as_hash = true

# Drop databases
db.execute "DROP TABLE IF EXISTS dictionaries"
db.execute "DROP TABLE IF EXISTS words"

# Create a database
db.execute "CREATE TABLE IF NOT EXISTS 
    dictionaries(
        dictionary_id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL UNIQUE,
        language TEXT NOT NULL
    )"
db.execute "CREATE TABLE IF NOT EXISTS 
    words(
        word_id INTEGER PRIMARY KEY, 
        label TEXT NOT NULL UNIQUE, 
        dictionary_id INTEGER NOT NULL,
        FOREIGN KEY (dictionary_id) REFERENCES dictionnaries (id) ON DELETE CASCADE ON UPDATE NO ACTION
    )"

# Execute a few inserts

test_words = []
test_dictionaries = {title: "Larousse 2020", language: "Francais"}

@title = test_dictionaries[:title]
@language = test_dictionaries[:language]

begin
    db.execute "INSERT INTO dictionaries (title, language) values (?, ?)", [@title, @language]
rescue => exception
    p exception
end

db.execute("select * from dictionaries") do |row|
    @dictionary = row
end

test_words << { label: "tornade",  dictionary_id: @dictionary["dictionary_id"] }
test_words << { label: "annoncer", dictionary_id: @dictionary["dictionary_id"] }
test_words << { label: "pointu",   dictionary_id: @dictionary["dictionary_id"] }
test_words << { label: "palette",  dictionary_id: @dictionary["dictionary_id"] }
test_words << { label: "saveur",   dictionary_id: @dictionary["dictionary_id"] }

p test_words

test_words.each do |words|
    db.execute "INSERT INTO words (label, dictionary_id) VALUES (?, ?)", words[:label], words[:dictionary_id]
end

#Execute inserts with parameter markers
#db.execute("INSERT INTO students (name, email, grade, blog) VALUES (?, ?, ?, ?)", [@name, @email, @grade, @blog])

db.execute("select * from words") do |row|
    @words = row
    p row
end

################################################################################# lecture fichier 
file = File.open("dictionary.text")
file_data = file.readlines.map(&:chomp)
file.close
p file_data
################################################################################ loop console
prompt = "> "
puts "Question asking for 1 or 2."
print prompt

while user_input = gets.chomp # loop while getting user input
  case user_input
  when "1"
    puts "First response"
    break # make sure to break so you don't ask again
  when "2"
    puts "Second response"
    break # and again
  else
    puts "Please select either 1 or 2"
    print prompt # print the prompt, so the user knows to re-enter input
  end
end