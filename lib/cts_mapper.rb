require "cts_mapper/version"

class CtsMapper
  def initialize
    @authors = {}
    parse_abbr_file
  end

  DATA_PATH = File.expand_path('../../data', __FILE__)

  def parse_abbr_file
    file = File.read(File.join(DATA_PATH, 'perseus.abb'))
    file.lines.each do |line|
      _, abbr, cts = line.strip.split("\t")
      author, work = parse_abbr(abbr)
      author_id, work_id = parse_cts(cts)

      add_entry(author, work, author_id, work_id)
    end
  end

  def parse_abbr(abbr)
    parts = abbr.split
    author = parts.pop
    work   = parts.join(' ')
    [author, work]
  end

  def parse_cts(cts)
    # they all start with abo:
    namespace, author_id, work_id = cts[4..-1].split(',')
    ["#{namespace}#{author_id}", "#{namespace}#{work_id}"]
  end

  def add_author(id, name)
    @authors[id] ||= Author.new(id, name)
  end

  def add_entry(author, work, author_id, work_id)
    author = add_author(author_id, author)
    author.add_work(work_id, work)
  end
end

class Author
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
    @works = {};
  end

  def add_work(id,  name)
    @works[id] = Work.new(id, name)
  end
end

class Work
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end
end
