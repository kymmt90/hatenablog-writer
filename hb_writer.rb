require 'hatenablog'

class HBWriter
  def post_entry(entry_text)
    title, id, content = parse_entry(entry_text)

    @blog ||= Hatenablog::Client.create
    posted_entry = @blog.post_entry(title, content)
    insert_id(entry_text, posted_entry.id)
  end

  def update_entry(entry_text)
    title, id, content = parse_entry(entry_text)

    @blog ||= Hatenablog::Client.create
    @blog.update_entry(id, title, content)
  end

  # 1st line      : title
  # 2nd line      : <!-- entryID -->
  # from 3rd line : content
  def parse_entry(entry_text)
    lines = entry_text.to_s.split("\n")
    if lines.size < 3 || lines[0] == ''
      raise HBWriterError, 'Entry format is invalid'
    end

    title   = lines[0]
    id      = lines[1].split(nil)[1].to_s
    content = lines[2..-1].join("\n")

    [title, id, content]
  end

  def insert_id(entry_text, id)
    lines = entry_text.to_s.split("\n")
    lines[1] = "<!-- #{id} -->"
    lines.join("\n")
  end
end

class HBWriterError < StandardError; end
