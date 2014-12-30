module Tatami
  module Parsers
    module Csv
      class HeaderParser
        include Tatami::Constants::HeaderNames

        HEADER_ROW_COUNT = 4
        def self.parse(data)
          root = Tatami::Models::Csv::Header.new(
              :name => ROOT,
              :depth => -1,
              :from => 0,
              :to => data[0].length - 1)
          (0..(HEADER_ROW_COUNT - 1)).each do |i|
            row = data[i]
            break if row.nil?
            current = nil
            (1..(row.length - 1)).each do |j|
              value = row[j]
              if value.to_s.strip != ''
                current = Tatami::Models::Csv::Header.new(
                    :name => value,
                    :depth => i,
                    :from => j,
                    :to => j,
                    :parent => Tatami::Models::Csv::Header.get_parent(root, i, j))
                current.parent.children.push(current)
              elsif !current.nil?
                parent_of_current =Tatami::Models::Csv::Header.get_parent(root, current.depth, current.from)
                current.to += 1 if current.to < parent_of_current.to
              end
            end
          end
          root
        end
      end
    end
  end
end