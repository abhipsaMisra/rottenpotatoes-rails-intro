class Movie < ActiveRecord::Base
    @ratings = ['G','PG','PG-13','R'];
    
    def self.ratings
       return @ratings
    end
    
    def self.init_is_rating_checked
       @is_checked = Hash.new
       @ratings.each do |rating|
           @is_checked[rating] = true
        end
        return @is_checked
    end
    
    def self.is_rating_checked(keys)
        @ratings.each do |rating|
            if keys.include?(rating)
                @is_checked[rating] = true
            else
                @is_checked[rating] = false
            end
        end
        return @is_checked
    end
end
