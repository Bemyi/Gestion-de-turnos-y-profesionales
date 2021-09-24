module Polycon
  module Utils
    def self.ensure_polycon_exists
      #acordate benja de cambiar a .polycon, lo deje sin . porque sino no podia testear (archivo oculto)
      Dir.chdir(ENV["HOME"])
      if not File.exists?("./polycon")
        Dir.mkdir("polycon")
      end
      Dir.chdir("polycon")
    end
  end
end