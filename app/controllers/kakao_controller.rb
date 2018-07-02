class KakaoController < ApplicationController
  def keyboard
    @keyboard = {
      :type => "buttons",
      buttons: ["로또", "메뉴", "고양이"]
    }
    render json: @keyboard
    # json형태로 렌더링
  end
  
  def friend_add
    User.create(user_key: params[:user_key], chat_room: 0)
    render nothing: true
  end
   
  def friend_delete
    user = User.find_by(user_key: params[:user_key])
    user.destroy
    render nothing: true
  end
 
  def chat_room
    user = User.find_by(user_key: params[:user_key])
    user.plus
    user.save
    render nothing: true
  end
  
  def message
    @text = "기본텍스트."
    @user_msg = params[:content] # content는 필드명중 하나.
    
    if @user_msg == "로또"
        @text = (1..45).to_a.sample(6).to_s
       elsif @user_msg =="메뉴"
        @text = ['20층','편의점','김밥까페'].sample + "으로 가세요."
       elsif @user_msg == "고양이"
        @url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
        @cat_xml = RestClient.get(@url)
        @cat_doc = Nokogiri::XML(@cat_xml) # :: <- 모듈안에있는것을 탐색한다.
        @cat_url = @cat_doc.xpath("//url").text
        @text=@cat_url
      elsif @user_msg =="태풍"
       @url = "https://api2.sktelecom.com/weather/severe/storm?version=2&isThatAll=Y"
       @typhoon_xml = RestClient.get(@url)
       @typhoon_doc = Nokogiri::XML(@typhoon_xml)
       @typhoon = @typhoon_doc.xpath("//course").text
       @text=@typhoon
    end
    
    @return_msg ={ 
      :text => @text
      # :photo => {}
      }
    @return_photo={
      :text => "고양이 다 있는데 나만 고양이 없떠",
      :photo => { 
        :url => @cat_url,
        :width => 720,
        :height => 630
        }
      }
    @return_keyboard ={ 
      :type => "buttons",
      buttons: ["로또", "메뉴", "고양이"]
    }
    
  if @user_msg == "고양이"
    @result = {
      :message => @return_photo,
      :keyboard => @return_keyboard
    }
    
  else
    @result = {
      :message => @return_msg,
      :keyboard => @return_keyboard
    }
    
  end
      
  
    render json: @result
  
  end
end
