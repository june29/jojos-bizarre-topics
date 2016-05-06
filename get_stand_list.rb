require 'open-uri'
require 'json'
require 'bundler'
Bundler.require

# https://ja.wikipedia.org/wiki/スタンド_(ジョジョの奇妙な冒険)
url = 'https://ja.wikipedia.org/wiki/%E3%82%B9%E3%82%BF%E3%83%B3%E3%83%89_%28%E3%82%B8%E3%83%A7%E3%82%B8%E3%83%A7%E3%81%AE%E5%A5%87%E5%A6%99%E3%81%AA%E5%86%92%E9%99%BA%29'

stands = []

html = Nokogiri::HTML(open(url).read)

tables = html.css('table.wikitable')
tables.each { |table|
  ths = table.css('tr th').to_a
  th = ths.find { |th| th.text =~ /スタンド名/ }

  stand_index = ths.index(th)
  operator_index = stand_index + 1

  prev_operator = nil
  prev_operator_counter = 0

  prev_stand = nil
  prev_stand_counter = 0

  trs = table.css('tr')
  trs.each { |tr|
    stand_td = tr.css('td').to_a[stand_index]
    operator_td = tr.css('td').to_a[operator_index]

    next if stand_td.nil?
    next if operator_td.nil?

    if operator_rowspan = operator_td&.attributes&.fetch('rowspan', nil)
      prev_operator = operator_td.text.to_s.gsub(/\n/, '')
      prev_operator_counter = operator_rowspan.value.to_i
    end

    stand_name = stand_td.text.to_s.gsub(/\n/, '')

    if prev_operator_counter > 0
      operator_name = prev_operator
      prev_operator_counter -= 1
    else
      operator_name = operator_td.text.to_s.gsub(/\n/, '')
    end

    next if [stand_name, operator_name].all? { |name| name == '不明' }

    stands << { stand_name: stand_name, operator_name: operator_name }
  }
}

puts stands.to_json
