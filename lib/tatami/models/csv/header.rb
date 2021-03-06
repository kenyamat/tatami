module Tatami
  module Models
    module Csv
      class Header < ModelBase
        attr_accessor :name, :depth, :from, :to, :parent, :children

        def initialize(param)
          super
          @children ||= []
        end

        def self.get_parent(header, depth, index)
          raise Tatami::WrongFileFormatError, 'depth <= header.depth' if depth <= header.depth
          return header if depth == 0

          parent = header
          while parent.children.any?
            h = parent
            parent.children.each { |child|
              if child.from <= index and child.to >= index
                return child if child.depth == (depth - 1)
                parent = child
                break
              end
            }
            break if h == parent
          end
          raise Tatami::WrongFileFormatError, 'Invalid header structure: name=%s' % [parent.name]
        end

        def self.get_header(header, index, depth = nil)
          5.times do
            if depth.nil?
              return header if header.children.empty?
            else
              return header if header.depth == depth
              return nil if header.children.empty?
            end
            header.children.each { |child|
              return get_header(child, index, depth) if child.from <= index and child.to >= index
            }
          end
          nil
        end

        def self.search(header, header_name)
          return header if header.name == header_name
          header.children.each { |child|
            result = search(child, header_name)
            return result unless result.nil?
          }
          nil
        end

        def self.get_string(header, header_name, row)
          searched_header = search(header, header_name)
          return nil if searched_header.nil?
          row[searched_header.from]
        end

        def self.get_bool(header, header_name, row)
          value = get_string(header, header_name, row)
          return false if value.to_s.strip == '' or value.casecmp('false') == 0
          return true if value.casecmp('true') == 0
          raise Tatami::WrongFileFormatError, 'Invalid Data Format. <%s>\'s value should be boolean type. value=%s' % [header_name, value]
        end

        def self.get_nullable_bool(header, header_name, row)
          value = get_string(header, header_name, row)
          return nil if value.to_s.strip == ''
          return false if value.casecmp('false') == 0
          return true if value.casecmp('true') == 0
          raise Tatami::WrongFileFormatError, 'Invalid Data Format. <%s>\'s value should be boolean type. value=%s' % [header_name, value]
        end

        def self.get_string_list(header, header_name, row)
          searched_header = search(header, header_name)
          return [] if searched_header.nil?
          result = []
          (searched_header.from..searched_header.to).each { |i|
            result.push(row[i]) unless row[i].nil?
          }
          result
        end

        def self.get_hash(header, header_name, row)
          searched_header = search(header, header_name)
          return {} if searched_header.nil?

          result = {}
          (searched_header.from..searched_header.to).each { |i|
            unless row[i].nil?
              child = get_header(header, i)
              result[child.name] = row[i]
            end
          }
          result
        end
      end
    end
  end
end
