class TextResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :user_id, as: :text
  field :bank_id, as: :text
  field :message, as: :text
  field :message_hash, as: :text
  field :data, as: :code
  # add fields here
end
