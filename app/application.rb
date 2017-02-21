class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        cart_string = @@cart.join("\n")
        resp.write "#{cart_string}\n"
      end
    elsif req.path.match(/add/)
      item_request = req.params["item"]
      resp.write add_item_to_cart(item_request)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def add_item_to_cart(item_request)
    if @@items.include?(item_request)
      @@cart << item_request
      return "added #{item_request}"
    elsif @@cart.include?(item_request)
      return "We don't have that item"
    else
      return "#{item_request} is not on your shopping list"
    end
  end

end
