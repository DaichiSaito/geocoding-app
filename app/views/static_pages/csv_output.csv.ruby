require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(address latitude longitude)
  csv << csv_column_names
  @geo.each do |geo|
    csv_column_values = [
      geo[:address],
      geo[:latitude],
      geo[:longitude]
    ]
    csv << csv_column_values
  end
end