module ApplicationHelper
    def data_br(data_us)
        data_us.strftime("%d/%m/%Y")
    end

    def locale(locale)
        locale == :en ? "Estados Unidos" : "Português do Brasil"
    end

    def teste
        
    end
end
