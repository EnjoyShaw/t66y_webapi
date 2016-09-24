require 'nokogiri'
require 'open-uri'
require 'awesome_print'

def parse_html(url, enable_proxy)
  html = ''
  open(url, proxy: enable_proxy ? 'http://127.0.0.1:8118' : nil) do |file|
    file.each_line { |line|
      html += line.encode 'utf-8', 'gbk'
    }
  end

  Nokogiri::HTML html
end

def parse_threads(doc)
  articles = []
  threads = doc.css 'tr.tr3'
  threads.each do |thread|
    link = thread.at_css('h3').at_css('a')
    unless link.content['P]'].nil?
      articles << {
          title: link.content,
          url: "http://t66y.com/#{link.attr 'href'}"
      }
    end
  end

  articles
end

def parse_thread(doc)
  pictures = []
  doc.css('input[type=image]').each do |img|
    pictures << img.attr('src')
  end

  pictures
end

def show_picture(url)
  base_path = File.join(File.expand_path '', 'ooxx_temp')
  file_name = [*('a'..'z'),*('A'..'Z'),*(0..9)].shuffle[0..9].join + '.jpg'
  file_path = File.join base_path, file_name

  File.open file_path, 'wb' do |file|
    file.write(open(url, proxy: 'http://127.0.0.1:8118').read)
  end
  file_path
  #system "imgcat #{file_path}"
end

def get_last_page(doc)
  link = doc.at_css('a#last').attr 'href'
  link['thread0806.php?fid=16&search=&page='] = ''
  link
end

def get_list(page)
  base_url = 'http://t66y.com/thread0806.php?fid=16'
  additional_params = "&search&page=#{page}"
  list_url = "#{base_url}#{additional_params}"
  list = parse_threads parse_html list_url, true
end