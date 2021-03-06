class Lesson < ApplicationRecord
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :skills, :objectives
  has_many :participations, dependent: :destroy
  has_many :messages, dependent: :destroy
  belongs_to :teacher, class_name: "User", foreign_key: :user_id
  GRADES = ["Terminale", "Première"]
  # GRADESSELECT = GRADES.each_with_index.map { |grade, index| [grade, index] }
  TOPICS = ["Mathématiques", "Physique-chimie", "Philosophie", "SVT", "Français", "Histoire"]

  include PgSearch

  pg_search_scope :search_by_grade,
      against: [:grade],
      using: {
        tsearch: { prefix: true }
      }
  pg_search_scope :search_by_topic,
      against: [:topic],
      using: {
        tsearch: { prefix: true }
      }

      pg_search_scope :search_by_subtopic,
          against: [:subtopic],
          using: {
            tsearch: { prefix: true }
          }
  pg_search_scope :search_by_keyword,
      against: [:name, :description, :subtopic],
      using: {
        tsearch: { prefix: true }
      }

  validates :name, presence: true
  validates :topic, presence: true
  validates :subtopic, presence: true
  validates :min_num_of_participants, presence: true
  validates :max_num_of_participants, presence: true
  validates :price, presence: true
  validates :starts_at, presence: true
  validates :date, presence: true
  validates :duration, presence: true
  validates :description, presence: true
  validates :summary, presence: true

  def update_price_per_user_down
    if self.participations.count.zero?
      self.current_price = price
      self.price_per_user = price
      self.save
    else
      self.current_price -= self.price.fdiv(2**(self.participations.count))
      self.price_per_user = self.current_price.fdiv(self.participations.count)
      self.save
    end
  end
  def update_price_per_user_up
    if self.participations.count > 1

      self.current_price += self.price.fdiv(2**(self.participations.count - 1))
      self.price_per_user = self.current_price.fdiv(self.participations.count)
      self.save
    end
  end

  def next_price_per_user
    if self.participations.count.zero?
      return price
    else
      next_current_price = self.current_price + self.price.fdiv((2 ** (self.participations.count)))
      return next_current_price.fdiv((self.participations.count + 1))
    end
  end
end
