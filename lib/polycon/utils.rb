module Polycon
  module Utils
    def self.ensure_polycon_exists
      Dir.chdir(ENV["HOME"])
      if not File.exists?("./.polycon")
        Dir.mkdir(".polycon")
      end
      Dir.chdir(".polycon")
    end

    def self.access_professional_directory(professional)
      Dir.chdir("./#{professional}")
    end
  end
end