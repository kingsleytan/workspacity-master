class PaymentsController < ApplicationController
  def index
    url_collection = 'https://www.billplz.com/api/v2/collections'
    url_bill = 'https://www.billplz.com/api/v2/bills'
    api_key = 'c0354ec2-d33f-46d6-8fcd-ee390ffb741f' #You can get the secret key in your billplz's setting account

    title = "Anything to explainn about your bill"

    #Create collection ID
    @collection = HTTParty.post(url_collection.to_str,
                  :body  => { :title => title }.to_json,
                  :basic_auth => { :username => api_key },
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

    #Create Bill
    @bill = HTTParty.post(url_bill.to_str,
            :body  => { :collection_id => @collection.parsed_response["id"], :email=> "email@gmail.com", :name=> "John Smith", :amount=>  "260", :callback_url=>  "http://localhost:3000/"}.to_json,
            :basic_auth => { :username => api_key },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

    redirect_to @bill.parsed_response["url"]
  end

  def get_bill
    url_bill = "https://www.billplz.com/api/v2/bills/#{params[:billplz][:id]}"
    api_key = 'c0354ec2-d33f-46d6-8fcd-ee390ffb741f' #You can get the secret key in your billplz's setting account

		@get_bill = HTTParty.get(url_bill,
			         :basic_auth => { :username => api_key },
			         :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
		@paid = @get_bill.parsed_response["paid"]
		#others data you can check at billplz api
  end

end
