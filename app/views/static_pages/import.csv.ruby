require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv_column_names = %w(住所 緯度 経度)
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