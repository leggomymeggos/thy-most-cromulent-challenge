require 'open-uri'
require 'net/http'
require 'nokogiri'

class Pangloss
  attr_reader :url, :parsed
  def initialize(url)
    @url = url
    @nokoified = nokoify
    @parsed = parsed
    @insult_arr = insult_arr
  end

  def mass_of_insults
    get_insults.map { |insult| insult.split(" ") }.flatten
  end

  def get_insults
    insults = @nokoified.search("pre").children[-2].to_s
    more_insults = @nokoified.search("pre").children[-1].to_s
    return [insults, more_insults]
  end

  def save
    File.write('shakespearean-insults.txt', mass_of_insults.join("\n"))
  end

  def generate_insult
    insults = []
    until insults.length == 3
      insults << @insult_arr.sample
      insults.uniq!
    end
    return "Thou #{insults.join(" ")}!"
  end

  private

  def insult_arr
    @insult_arr ||= mass_of_insults
  end

  def parsed
    @parsed ||= URI.parse(url)
  end

  def nokoify
    @nokoified ||= Nokogiri::HTML(open(url))
  end
end
