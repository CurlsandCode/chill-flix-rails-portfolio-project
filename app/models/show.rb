class Show < ApplicationRecord
  validates :name, presence: true
  validates :air_date, presence: true
  validates :air_time, presence: true
  validates :description, presence: true

  belongs_to :network
  has_many :programs
  has_many :users, through: :programs

  has_many :show_genres
  has_many :genres, through: :show_genres

  has_many :reviews

  def genres_attributes=(genres_hashes)
    genres_hashes.each do |i, genre_attributes|
      if genre_attributes[:name].present?
        genre = Genre.find_or_create_by(name: genre_attributes[:name])
        if !self.genres.include?(genre)
          self.show_genres.build(genre: genre)
        end
      end
    end
  end


  def self.add_to_shows(current_user, show_id)
    show = current_user.shows.find_by(id: show_id)

    if !show
      current_user.shows << Show.find(show_id)
      current_user.save
    end
  end
end
