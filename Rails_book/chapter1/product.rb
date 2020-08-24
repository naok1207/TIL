class Product
    attr_accessor :price

    def total_price
        price * Tax.rate
    end
end

class OrderedItem
    attr_accessor :unit_price, :volume

    def initialize(unit_price, volume)
        @unit_price = unit_price
        @volume = volume
    end

    def price
        unit_price * volume
    end

    def total_price
        price * Tax.rate
    end
end

class Tax
    def self.rate
        1.08
    end
end