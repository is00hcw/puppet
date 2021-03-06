class Puppet::FileSystem::MemoryImpl
  def initialize(*files)
    @files = files + all_children_of(files)
  end

  def exist?(path)
    path.exist?
  end

  def directory?(path)
    path.directory?
  end

  def executable?(path)
    path.executable?
  end

  def children(path)
    path.children
  end

  def each_line(path, &block)
    path.each_line(&block)
  end

  def pathname(path)
    find(path)
  end

  def basename(path)
    path.duplicate_as(File.basename(path_string(path)))
  end

  def path_string(object)
    object.path
  end

  def assert_path(path)
    if path.is_a?(Puppet::FileSystem::MemoryFile)
      path
    else
      find(path) or raise ArgumentError, "Unable to find registered object for #{path.inspect}"
    end
  end

  private

  def find(path)
    @files.find { |file| file.path == path }
  end

  def all_children_of(files)
    children = files.collect(&:children).flatten
    if children.empty?
      []
    else
      children + all_children_of(children)
    end
  end
end
