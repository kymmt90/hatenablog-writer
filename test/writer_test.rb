require 'test/unit'

require './hb_writer'

class HBWriterTest < Test::Unit::TestCase
  def setup
    @sut = HBWriter.new
  end

  sub_test_case 'parse valid entry file' do
    setup do
      @entry = open('test/fixtures/entry.md')
    end

    teardown do
      @entry.close
    end

    test 'get the entry title' do
      result = @sut.parse_entry(@entry.read)
      assert_equal('Test Title', result[0])
    end

    test 'get the entry content' do
      result = @sut.parse_entry(@entry.read)
      assert_equal("This is\n**the test**\nentry.", result[1])
    end
  end

  sub_test_case 'parse invalid entry file' do
    test 'title only' do
      open('test/fixtures/title_only_entry.md') do |f|
        assert_raise(HBWriterError.new("Entry format is invalid")) do
          @sut.parse_entry(f.read)
        end
      end
    end

    test 'title is empty' do
      open('test/fixtures/title_empty_entry.md') do |f|
        assert_raise(HBWriterError.new("Entry format is invalid")) do
          @sut.parse_entry(f.read)
        end
      end
    end

    test 'empty' do
      open('test/fixtures/empty_entry.md') do |f|
        assert_raise(HBWriterError.new("Entry format is invalid")) do

          @sut.parse_entry(f.read)
        end
      end
    end
  end
end
