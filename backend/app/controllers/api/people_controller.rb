class Api::PeopleController < ApplicationController
  def index
    people = Person.all
    render json: people.as_json(only: [:id, :name])
  end

  private

  def person_params
    params.require(:person).permit(:id, :name)
  end
end