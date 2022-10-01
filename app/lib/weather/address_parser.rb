module Weather
  class AddressParser
    delegate :prenum, :number, :sufnum, :street, :city, :state, :zip, :plus4, :country, to: :@parsed_address

    attr_reader :address

    def initialize(address)
      @address = address
    end

    def parse_zip
      @parsed_address ||= Indirizzo::Address.new(address)
    end
  end
end
