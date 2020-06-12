class LikesController < ApplicationController

  def index
    @likes = Like.all
  end

  def show
    #array containing all likes from the current_pet
    @my_likes_ids = current_pet.likes_as_liker.all
    #array containing all likes towards the current_pet
    @iam_liked_ids = current_pet.likes_as_liked.all
    @matches = @my_likes_ids.where(match: true)
  end

  def new
    @like = Like.new
  end 

  def create
    @pet = Pet.find(pet_params.id)
    @like = Like.new(liker: current_pet, liked: @pet)
    # already_liked() and matches_back() are defined in application_controller.rb
    if already_liked(current_pet, @pet)
      @like.match = true
      matches_back(current_pet, @pet)  
    end
    @like.save

  end

  def already_liked(current_pet, other_pet)
    return current_pet.likes_as_liked.where(liker_id: other_pet).exists?
  end

  def matches_back(current_pet, other_pet)
    back_like = current_pet.likes_as_liked.where(liker_id: other_pet)
    back_like.update(match: true)
  end


  def destroy
    @pet = Pet.find(pet_params.id)
    @my_likes_ids = current_pet.likes_as_liker.all
    @unliked = @my_likes_ids.where(liked: @pet)
    # already_liked() and unmatch() are defined in application_controller.rb
    if already_liked(current_pet, @pet)
      unmatch(current_pet, @pet)
    end
    @unliked.destroy

  end

  def unmatch(current_pet, other_pet)
    iam_liked_ids = current_pet.likes_as_liked.all
    unmatched = iam_liked_ids.where(liker: other_pet)
    unmatched.match = false
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :animal, :chip_number, :breed, :sex, :age, :id)
  end

end
