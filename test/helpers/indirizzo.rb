module Indirizzo
  class Address
    attr_reader :prenum, :number, :sufnum, :street, :city, :state, :zip, :plus4, :country

    def initialize(address)
      address == "123" ? invalid_address : valid_address
    end

    private

    def valid_address
      @city = ["cupertino"]
      @country = ""
      @full_state = "ca"
      @number = ""
      @options = { :expand_streets => true }
      @plus4 = nil
      @prenum = ""
      @state = "CA"
      @street = ["1 apple park way", "first apple park way", "one apple park way", "cupertino"]
      @sufnum = ""
      @text = "One Apple Park Way, Cupertino, CA 95014"
      @zip = "95014"
    end

    def invalid_address
      @city = []
      @country = nil
      @full_state = ""
      @number = "123"
      @options = { :expand_streets => true }
      @plus4 = ""
      @prenum = nil
      @state = ""
      @street = []
      @sufnum = ""
      @text = "123"
      @zip = ""
    end
  end
end
