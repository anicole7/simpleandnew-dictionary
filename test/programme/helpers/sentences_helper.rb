# Helper pour la gestion des phrases du menu et input utilisateur

class SentencesHelper
    # Input

    def new_line
        puts "\n"
    end

    def prompt
        print "> "
    end

    def prompt_word_to_add
        print "Saisissez un ou plusieurs mots separes d'une virgule, à ajouter > "
    end

    def prompt_word_to_remove
        print "Saisissez un ou plusieurs mots separes d'une virgule, à retirer > "
    end

    def saisie
        return self.remove_space((gets.chomp).downcase)
    end

    def saisie_string_words_data
        return self.remove_space((gets.chomp).downcase).gsub(/[^A-Za-z,]/, "")
    end

    def saisie_string_data
        return self.remove_space((gets.chomp).downcase).gsub(/[^A-Za-z]/, "")
    end

    def saisie_wildcards_data
        return self.remove_space((gets.chomp).downcase).gsub(/[^A-Za-z_%]/, "")
    end

    def saisie_integer_data
        return self.remove_space((gets.chomp).downcase).gsub(/[^0-9]/, "")
    end

    def remove_space(string)
        return string.gsub(/\s+/, "")
    end
    
    # Greetings
    def welcome_sentence 
        puts "Bonjour et bienvenu dans le dictionnaire. Quelle action souhaitez-vous exécuter ? "
    end

    def bye_sentence 
        puts "Merci d'avoir utilisez le dictionnaire simple and new"
    end

    def words_found_search(words) 
        if words.count.positive?
            list = "#{words.count} mot(s) trouvé(s) dans le dictionnaire : \n"
            words.each_with_index do |label, index|
                list += "#{label} " + ((index+1) < words.count ? ", " : "")
            end
        else
            list = "Aucun mot not correspond à cette recherche"
        end

        puts list
    end

    def words_in_dictionnary(words) 
        if words.count.positive?
            list = "#{words.count} mots dans le dictionnaire : \n"
            words.each_with_index do |label, index|
                list += "#{label} " + ((index+1) < words.count ? ", " : "")
            end
        else
            list = "Aucun mot dans le dictionnaire"
        end

        puts list
    end

    # Words removed
    def words_removed_from_dictionnary(words) 
        words = words.uniq
        if words.count.positive?
            list = "#{words.count} mot(s) supprimé(s) du dictionnaire : \n"
            words.each_with_index do |label, index|
                list += "#{label} " if !list.include?("#{label}")
                list += ((index+1) < words.count ? ", " : "")
            end
        else
            list = "Aucun mot n'a été supprimé du dictionnaire"
        end

        puts list
    end

    # Action possibilities
    def action_selection
        puts "
        1 - Ajouter un mot au dictionnaire ? 
        2 - Retirer un mot du dictionnaire ?
        3 - Rechercher un mot dans le dictionnaire 
        4 - Afficher les mots du dictionnaire (ordre alphabétique).
        q - Pour quitter (les données seront sauvegardées)"
    end 

    def search_two_choices
        puts "Vous avez la possibilité de choisir entre deux méthodes, a ou b
        a - 4 questions vous seront posées
        b - recherche par wildcards _ et % "
    end

    def start_again
        puts "Vous pouvez choisir une nouvelle action."
    end

    # Method A
    def description_method_a
        puts "Vous avez choisi la méthode a, voici 4 questions"
    end

    # Method A, 4 questions
    # On part du principe que pour min et max l'utilisateur 
    # doit saisir un nombre, sinon la valeur sera nil
    def min_size_question
        puts "Quelle est la taille minimale du mot recherché ?"
        prompt
        return saisie_integer_data
    end
    def max_size_question
        puts "Quelle est la taille maximale du mot recherché ?"
        prompt
        return saisie_integer_data
    end
    # On part du principe que pour first et last l'utilisateur 
    # doit saisir une lettre, sinon la valeur sera nil
    def first_letter_question
        puts "Quelle est la première lettre du mot recherché ?"
        prompt
        return saisie_string_data
    end

    def last_letter_question
        puts "Quelle est la dernière lettre du mot recherché ?"
        prompt
        return saisie_string_data
    end

    # Method B
    def description_method_b
        puts "
        Vous avez choisi la méthode b. 
        Ecrivez un mot en incluant _ pour une lettre quelconque et %  pour un ensemble de lettres. 
        Exemple _on%r pour BonJOUr, BonSOIr ou encore BonHEUr"
        prompt
        return saisie_wildcards_data
    end

    # Wrong choice
    def wrong_method_choice
        puts "Ceci ne correspond à aucune méthode."
    end

    def wrong_action_choice
        puts "Ceci ne correspond à aucune action. "
    end

    # Word added
    def display_word_added(added_word)
        puts "Le mot " + added_word + " a ete ajoute"    
    end

    # Word already exists
    def word_exists(word)
        puts "Le mot #{word} existe dans le dictionnaire"
    end

    # Wrong word input
    def word_wrong_input
        puts "Erreur de saisie: Mot vide ou ne contenant que des caractères interdits"
    end

    # Proc
    def first_entrie
        puts "******************************** Simple & New : MENU *********************************************"
        welcome_sentence
        action_selection
        prompt
    end

    def end_loop
        start_again
        action_selection
        prompt
    end

    def a_entrie
        description_method_a
        min = min_size_question
        max = max_size_question
        first = first_letter_question
        last = last_letter_question

        return { min: min != "" ? min : nil, 
                 max: max != "" ? max : nil, 
                 first: first != "" ? first : nil, 
                 last: last != "" ? last : nil }
    end

end