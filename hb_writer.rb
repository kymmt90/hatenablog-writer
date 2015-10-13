require 'hatenablog'

class HBWriter
  def post_entry(entry_text)
    title, content = parse_entry(entry_text)

    @blog ||= Hatenablog::Client.create
    @blog.post_entry(title, content)
  end

  # 1st line      : title
  # 2nd line      : ignored
  # from 3rd line : content
  def parse_entry(entry_text)
    lines = entry_text.to_s.split("\n")
    if lines.size < 3 || lines[0] == ''
      raise HBWriterError, 'Entry format is invalid'
    end

    title   = lines[0]
    content = lines[2..-1].join("\n")

    [title, content]
  end
end

class HBWriterError < StandardError; end
