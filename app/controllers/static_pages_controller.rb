class StaticPagesController < ApplicationController
  
  def home
    
    # coords = Geocoder.coordinates(
    #   "ふぁえおぐぢえおあう"
    # )
    
    # flash[:danger] = coords || "にる"
  end
  
  def import
    
    if params[:file].present? && 
      params[:file].original_filename && 
      File.extname(params[:file].original_filename) == ".csv" # パラメータのoriginal_filenameでチェック
      # 例外を捕捉してエラーが起きないようにする
      begin
        table = CSV.table(params[:file].path) # => #<CSV::Table mode:col_or_row row_count:6>
        puts "テールの行数！！！"
        puts table.size
        
        
        if table.size > 99
          flash[:danger] = "100行以内にしてください！！"
          raise something error  
        end
      
        @geo = []
        CSV.foreach(params[:file].path, headers: false) do |row|
          
          coords = Geocoder.coordinates(
            "#{row[0]}"
          )
          sleep(0.25)  
          if coords.nil?
            latitude = "変換失敗"
            longitude = "変換失敗"
          else
            latitude = coords[0]
            longitude = coords[1]
            # puts latitude
            # puts longitude
          end
          # geo = {address: row[0], latitude: coords[0], longitude: coords[1]}
          geo = {address: row[0], latitude: latitude, longitude: longitude}
          @geo.push(geo)
        end
        
        
        request.format = :csv #これないとうまくいかない。リクエスト中のformat属性を :csvに無理やり変えることで、~~~.csv.rubyがテンプレートとして返却されるっぽい。
        # これもないとダメっぽい
        puts @geo
        respond_to do |format|
          format.html
          format.csv do
            send_data render_to_string, filename: "output.csv", type: :csv
          end
        end
        # redirect_to action: 'home'
        return false # 失敗しなければここまで来る。double render error対策にreturn falseして終了
      rescue # 途中でエラー(CSVのnewでエラーが起きたら)ここに飛ぶ
        # 特別な後片付けは必要なさそうなので、そのまま。
        # エラーの種類が特定できるなら、rescueの引数で切り分けてメッセージをflashに入れるとかのOK
        # flash[:danger] = "CSV形式のファイルを選択してください"
      end
      
      
      
    else
      flash[:danger] = "CSV形式のファイルを選択してください"
    end
    # パラメータの条件ではねられたり、途中でエラーが起きたりした時はここまで来る
    
    redirect_to action: 'home'
    
  end
  
  
  def csv_output
    
    @geo = [{address: "埼玉県川越市下新河岸45", latitude: "1000203", longitude: "13957362"},{address: "埼玉県川越市下新河岸45", latitude: "1000203", longitude: "13957362"}]
    
    puts @geo[0]
    
    
    # @geo = {address: "埼玉県川越市下新河岸45", latitude: "1000203", longitude: "13957362"}
    # send_data render_to_string, filename: "csv_output.csv", type: :csv
  end
  
end
