json.extract! raw_order, :id, :delivery_date, :delivery_shift, :origin_name, :origin_raw_line_1, :origin_city, :origin_state, :origin_zip, :client, :name, :destination_raw_line_1, :destination_city, :destination_state, :destination_zip, :phone_number, :mode, :purchase_order_number, :volume, :handling_unit_quantity, :handling_unit_type, :created_at, :updated_at
json.url raw_order_url(raw_order, format: :json)