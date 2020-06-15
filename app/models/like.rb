class Like < ApplicationRecord
  after_commit :match, on: :create
#  after_commit :new_match_send, on :create
  before_destroy :unmatch, on: :destroy

  belongs_to :liker, class_name: "Pet"
  belongs_to :liked, class_name: "Pet"
  validates :liked, uniqueness: { scope: [:liker]}
  validate :different_pets

  def different_pets
    if self.liked == self.liker
      errors.add(:liked, 'Narcissisme!')
      errors.add(:liker, 'Narcissisme!')
    end
  end

  def current_pet
    current_pet = Pet.find(current_user.default_pet_id)
  end

  def already_liked?
    liker_pet = Pet.find(self.liked_id)
    liked_pet = Pet.find(self.liker_id)
    return Like.where(liked_id: liked_pet.id, liker_id: liker_pet.id).exists?
  end

  def match
    if already_liked? == true
      self.match = true
      match_back = Like.where(liker_id: self.liked_id,liked_id: self.liker_id)
      match_back.first.update(match: true)
    else
      self.match = false
    end
  end

  def unmatch
    if self.match == true
      unmatched = Like.where(liker_id: self.liked_id,liked_id: self.liker_id)
      unmatched.first.update(match: false)
    end
  end

  def new_match_send
    if already_liked?
      UserMailer.new_match_email(self).deliver_now
    end
  end

end
