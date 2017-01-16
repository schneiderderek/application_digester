require "application_digester/version"

class ApplicationDigester
  # Taking into account the location of every file helps capture changes such as
  # a file moving location, but the contents remain unchanged.
  def digest
    Digest::SHA256.hexdigest(file_digests.join + paths.join)
  end

  private

  def file_digests
    files.map { |path| Digest::SHA256.hexdigest(File.read(path)) }
  end

  def files
    paths.select { |path| File.file?(path) }
  end

  def paths
    all_paths - exclude_paths
  end

  def all_paths
    Dir[Rails.root.join('./**/*')]
  end

  def exclude_paths
    Dir[*EXCLUDE_DIRS.map do |dir_name|
      Rails.root.join("#{dir_name}/**/*")
    end]
  end

  EXCLUDE_DIRS = %w(log tmp).freeze
end
