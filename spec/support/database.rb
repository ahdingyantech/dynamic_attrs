def rebuild_model options = {}
  ActiveRecord::Base.connection.create_table :dummies
end
