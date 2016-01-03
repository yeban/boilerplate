Sequel.migration do
  up do
    create_table :posts  do

      String   :id,
        primary_key: true

      String   :title,
        null:    false,
        unique:  true

      String   :text,
        null:    false
    end
  end

  down do
    drop_table :posts
  end
end
