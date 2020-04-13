namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando o BD") { %x(rails db:drop) }
      show_spinner("Criando o BD") { %x(rails db:create) }
      show_spinner("Migrando o BD") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)

    else
      puts "Você não está no ambiente de desenvolvimento"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas") do
      coins =[
              {
                  description: "bitcoin",
                  acronym: "BTC",
                  url_image: "https://steemitimages.com/640x0/https://cdn.steemitimages.com/DQmd6vzKDCAFapifCYBZ4gJ6SruTvdcuEkHZ6qeADU2pUNn/bitcoin.png",
                  mining_type: MiningType.find_by(acronym: "PoW")
              },

              {
                  description: "Dash",
                  acronym: "DASH",
                  url_image: "https://guiadobitcoin.com.br/wp-content/uploads/2018/06/Dash-Logo.png",
                  mining_type: MiningType.all.sample
              },

              {
                  description: "ethereum",
                  acronym: "ETH",
                  url_image: "https://www.comocomprarcriptomoedas.com/wp-content/uploads/2018/02/ETHEREUM-LOGO-2.png",
                  mining_type: MiningType.all.sample
              }
            ]
      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do 
    show_spinner("Cadastrando os tipos de mineração") do
      mining_types = [
        {
          description: "Proof of Work",
          acronym: "PoW"
        },
        {
          description: "Proof of Stake",
          acronym: "PoS"
        },
        {
          description: "Proof of Capacity",
          acronym: "PoC"
        }
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private
    def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}...")
        spinner.auto_spin
          yield
        spinner.success("(#{msg_end})")
    end

end