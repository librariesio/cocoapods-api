xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Cocoapods Specs recent commits"
    xml.description "Recent commits to Cocoapods Spec repo that have been synced to this repo"
    xml.link "http://cocoapods.libraries.io"

    @entries.each do |entry|
      xml.item do
        xml.title entry[:comments]
        xml.link "http://cocoapods.libraries.io/pods/#{entry[:comments].split(' ')[1]}"
        xml.description "#{entry[:author_name]} made a commit on #{entry[:date]}"
        xml.pubDate entry[:date]
        xml.guid entry[:guid]
      end
    end
  end
end
