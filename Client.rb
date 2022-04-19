require "socket"

class Client
    
    def initialize(server) #definim una funció d'inicialització a partir d'una instància del servidor
        @server = server
        @request = nil #definim aquesta variable per tal de poder rebre missatges
        @response = nil #definim aquesta variable per tal de poder enviar missatges
        listen
        send
        @request.join
        @response.join
    end

    def send
        puts "Enter the username: "
        @request = Thread.new do
            loop {
                msg = $stdin.gets.chomp
                @server.puts(msg)
            }
        end
    end

    def listen
        @response = Thread.new do
            loop {
                msg = @server.gets.chomp
                puts "#{msg}" 
            }
        end
    end
end

server = TCPSocket.open("localhost", 5050)
Client.new(server)

