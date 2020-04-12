# Helper pour la gestion des phrases du menu et input utilisateur

class SentencesHelper
    # Input
    def prompt
        print "> "
    end

    def prompt_word_to_add
        print "Saisissez le mot à ajouter > "
    end

    def prompt_word_to_remove
        print "Saisissez le mot à retirer > "
    end

    def saisie
        return self.remove_space((gets.chomp).downcase)
    end

    def remove_space(string)
        return string.gsub(/\s+/, "")
    end
    
    # Greetings
    def welcome_sentence 
        puts "Bonjour et bienvenu dans le dictionnaire. Quelle action souhaitez-vous exécuter ?"
    end

    def bye_sentence 
        puts "Merci d'avoir utilisez le dictionnaire simple and new"
    end

    # Action possibilities
    def action_selection
        puts "
        1 - Ajouter un mot au dictionnaire ? 
        2 - Retirer un mot du dictionnaire ? - 
        3 - Rechercher un mot dans le dictionnaire"
    end 

    def search_two_choices
        puts "Vous avez la possibilité de choisir entre deux méthodes, a ou b
        a - 4 questions vous seront posées
        b - recherche par wildcards _ et % "
    end

    def start_again
        puts "Si vous souhaitez arreter, tappez q. Sinon choisissez une action."
    end

    # Method A
    def description_method_a
        puts "Vous avez choisi la méthode a, voici 4 questions"
    end

    # Method A, 4 questions
    def min_size_question
        puts "Quelle est la taille minimale du mot recherché ?"
        prompt
        return saisie
    end

    def max_size_question
        puts "Quelle est la taille maximale du mot recherché ?"
        prompt
        return saisie
    end

    def first_letter_question
        puts "Quelle est la première lettre du mot recherché ?"
        prompt
        return saisie
    end

    def last_letter_question
        puts "Quelle est la dernière lettre du mot recherché ?"
        prompt
        return saisie
    end

    # Method B
    def description_method_b
        puts "
        Vous avez choisi la méthode b. 
        Ecrivez un mot en incluant _ pour une lettre quelconque et %  pour un ensemble de lettres. 
        Exemple _on%r pour BonJOUr, BonSOIr ou encore BonHEUr"
        prompt
        return saisie
    end

    # Wrong choice
    def wrong_method_choice
        puts "Ceci ne correspond à aucune méthode."
    end

    def wrong_action_choice
        puts "Ceci ne correspond à aucune action."
    end

    # Word already exists
    def display_words_added(words, added_word)
        p words.count > 1 ? ("Les mots" + added_word + " ont etes ajoutes") : ("Le mot" + added_word + " a ete ajoute")         
    end

    # Word already exists
    def word_exists(word)
        p "Le mot #{word} existe dans le dictionnaire"
    end

    # Empty word
    def word_empty
        p "Vous ne pouvez pas enregistrer un mot vide"
    end

    # Proc
    def first_entrie
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