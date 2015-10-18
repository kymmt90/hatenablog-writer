require 'hatenablog'

class HBWriter
  def initialize
    @blog = Hatenablog::Client.create
  end

  def post_entry(entry_text)
    title, id, content = parse_entry(entry_text)
    posted_entry = @blog.post_entry(title, content)
    insert_id(entry_text, posted_entry.id)
  end

  def update_entry(entry_text)
    title, id, content = parse_entry(entry_text)
    id = find_entry_id(title) if id.empty?
    @blog.update_entry(id, title, content)
  end

  def minor_update_entry(entry_text)
    title, id, content = parse_entry(entry_text)
    id    = find_entry_id(title) if id.empty?
    entry = @blog.get_entry(id)
    draft = entry.draft? ? 'yes' : 'no'
    @blog.update_entry(id,               title, content,
                       entry.categories, draft, entry.updated.iso8601)
  end

  def delete_entry(entry_text)
    title, id, content = parse_entry(entry_text)
    id = find_entry_id(title) if id.empty?
    @blog.delete_entry(id)
    delete_id(entry_text)
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

  # find an entry ID by its title.
  # return empty string if the entry is not found.
  def find_entry_id(title)
    feed = @blog.next_feed
    while true
      found_entry = feed.entries.find { |entry| title == entry.title }
      return found_entry.id unless found_entry.nil?
      feed = @blog.next_feed(feed)
      raise HBWriterError, "entry is not found: #{title}" if feed.nil?
    end
  end

  def insert_id(entry_text, id)
    lines = entry_text.to_s.split("\n")
    lines[1] = "<!-- #{id} -->"
    lines.join("\n")
  end

  def delete_id(entry_text)
    lines = entry_text.to_s.split("\n")
    lines[1] = ''
    lines.join("\n")
  end
end

class HBWriterError < StandardError; end
