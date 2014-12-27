module Tatami
  module Validators
    module Csv
      class HeaderValidator
        def self.validate(header)
          # header
          validate_not_nil(header, Tatami::Constants::HeaderNames::ROOT)
          validate_name(header, Tatami::Constants::HeaderNames::ROOT)
          validate_having_children(header, 2)
          validate_depth_from_to(header, -1)
          validate_having_child(header, Tatami::Constants::HeaderNames::ARRANGE)
          validate_having_child(header, Tatami::Constants::HeaderNames::ASSERTION)
          # Arrange
          validate_arrange(header.children[0])
          # Assertion
          validate_assertion(header.children[1])
          true
        end

        def self.validate_arrange(header)
          validate_not_nil(header, Tatami::Constants::HeaderNames::ARRANGE)
          validate_name(header, Tatami::Constants::HeaderNames::ARRANGE)
          validate_having_children(header)
          validate_having_child(header, Tatami::Constants::HeaderNames::HTTP_REQUEST_ACTUAL)

          header.children.each { |child|
            name = child.name
            if name == Tatami::Constants::HeaderNames::HTTP_REQUEST_ACTUAL or
                name == Tatami::Constants::HeaderNames::HTTP_REQUEST_EXPECTED
              validate_http_request(child);
            else
              raise ArgumentError, 'Invalid Header Format. <%s> has unknown child. Name=%s' % [ header.name, name ]
            end
          }
          true
        end

        def self.validate_http_request(header)
          validate_not_nil(header, Tatami::Constants::HeaderNames::HTTP_REQUEST_EXPECTED.gsub(' Expected', ''))
          validate_name(header, Tatami::Constants::HeaderNames::HTTP_REQUEST_EXPECTED, Tatami::Constants::HeaderNames::HTTP_REQUEST_ACTUAL)
          validate_having_child(header, Tatami::Constants::HeaderNames::BASE_URI)
          header.children.each { |child|
            name = child.name
            if [
                Tatami::Constants::HeaderNames::BASE_URI,
                Tatami::Constants::HeaderNames::METHOD,
                Tatami::Constants::HeaderNames::USER_AGENT,
                Tatami::Constants::HeaderNames::PATH_INFOS,
                Tatami::Constants::HeaderNames::FRAGMENT,
                Tatami::Constants::HeaderNames::CONTENT ].include?(name)
              validate_not_having_children(child)
            elsif [
                Tatami::Constants::HeaderNames::HEADERS,
                Tatami::Constants::HeaderNames::COOKIES,
                Tatami::Constants::HeaderNames::QUERY_STRINGS ].include?(name)
              validate_having_children(child)
              validate_not_having_grand_children(child)
            else
              raise ArgumentError, 'Invalid Header Format. <%s> a has unknown child. Name=%s' % [ header.name, name ]
            end
          }
          true
        end

        def self.validate_assertion(header)
          validate_not_nil(header, Tatami::Constants::HeaderNames::ASSERTION)
          validate_name(header, Tatami::Constants::HeaderNames::ASSERTION)
          validate_having_children(header)

          header.children.each { |child|
            name = child.name
            if [
                Tatami::Constants::HeaderNames::URI,
                Tatami::Constants::HeaderNames::STATUS_CODE,
                Tatami::Constants::HeaderNames::XSD ].include?(name)
              validate_not_having_children(child)
            elsif [
                Tatami::Constants::HeaderNames::HEADERS,
                Tatami::Constants::HeaderNames::COOKIES ].include?(name)
              validate_having_children(child)
              validate_not_having_grand_children(child)
            elsif [
                Tatami::Constants::HeaderNames::CONTENTS ].include?(name)
              validate_contents(child)
            else
              raise ArgumentError, 'Invalid Header Format. <%s> has a unknown child. Name=%s' % [ header.name, name ]
            end
          }
          true
        end

        def self.validate_contents(header)
          validate_not_nil(header, Tatami::Constants::HeaderNames::CONTENTS)
          validate_having_children(header)
          validate_having_child(header, Tatami::Constants::HeaderNames::NAME)
          validate_having_child(header, Tatami::Constants::HeaderNames::EXPECTED)
          validate_having_child(header, Tatami::Constants::HeaderNames::ACTUAL)

          header.children.each { |child|
            name = child.name
            if [
                Tatami::Constants::HeaderNames::NAME,
                Tatami::Constants::HeaderNames::IS_LIST,
                Tatami::Constants::HeaderNames::IS_DATE_TIME,
                Tatami::Constants::HeaderNames::IS_TIME ].include?(name)
              validate_not_having_children(child)
            elsif [
                Tatami::Constants::HeaderNames::EXPECTED,
                Tatami::Constants::HeaderNames::ACTUAL ].include?(name)
              validate_contents_item(child)
            else
              raise ArgumentError, 'Invalid Header Format. <%s> has a unknown child. Name=%s' % [ header.name, name]
            end
          }
          true
        end

        def self.validate_contents_item(header)
          validate_having_children(header)

          header.children.each { |child|
            name = child.name
            if [
                Tatami::Constants::HeaderNames::VALUE,
                Tatami::Constants::HeaderNames::QUERY,
                Tatami::Constants::HeaderNames::ATTRIBUTE,
                Tatami::Constants::HeaderNames::EXISTS,
                Tatami::Constants::HeaderNames::PATTERN,
                Tatami::Constants::HeaderNames::FORMAT,
                Tatami::Constants::HeaderNames::FORMAT_CULTURE,
                Tatami::Constants::HeaderNames::URL_DECODE ].include?(name)
              validate_not_having_children(child)
            else
              raise ArgumentError, 'Invalid Header Format. <%s> has a unknown child. Name=%s' % [ header.name, name ]
            end
          }
          true
        end

        def self.validate_not_nil(header, name)
          raise ArgumentError, 'Invalid Header Format. Header <%s> is not found.' % [name] if header.nil?
          true
        end

        def self.validate_depth_from_to(header, depth)
          raise ArgumentError, "Invalid Header Format. <%s>'s From/To is invalid." % [ header.name ] if header.from > header.to
          raise ArgumentError, "Invalid Header Format. <%s>'s Depth is invalid. Expected=%s, Actual=%s" % [ header.name, depth, header.depth ] if header.depth != depth
          header.children.each { |child|
            raise ArgumentError, "Invalid Header Format. <%s>'s From is invalid. <%s>'s From=%s, %s's parent's From=%s" % [ child.name, child.name, child.from, child.name, header.from ] if header.from > child.from
            raise ArgumentError, "Invalid Header Format. <%s>'s To is invalid. <%s>'s To=%s, %s's parent's To=%s" % [ child.name, child.name, child.to, child.name, header.to ] if header.to < child.to
            validate_depth_from_to(child, depth + 1)
          }
          true
        end

        def self.validate_name(header, expected, expected2 = nil)
          if expected2.nil?
            if header.name != expected
              raise ArgumentError, 'Invalid Header Format. Invalid Header Name. Expected=%s, Actual=%s' % [ expected, header.name ]
            else
              return true
            end
          end
          if header.name != expected and header.name != expected2
            raise ArgumentError, 'Invalid Header Format. Invalid Header Name. Expected=%s, Actual=%s' % [ expected, header.name ]
          end
          true
        end

        def self.validate_having_child(header, child_name)
          test = false
          header.children.each { |child|
            if child.name == child_name
              test = true
              break
            end
          }
          raise ArgumentError, 'Invalid Header Format. %s should have <%s> as his child.' % [ header.name, child_name ] if !test
          true
        end

        def self.validate_having_children(header, count = nil)
          raise ArgumentError, "Invalid Header Format. %s's children are not found. %s should have children." % [ header.name, header.name ] if header.children.nil? or header.children.empty?
          raise ArgumentError, "Invalid Header Format. Count of <%s>'s children is invalid. Expected=%s, Actual=%s" % [ header.name, count, header.children.count ] if !count.nil? and header.children.count != count
          true
        end

        def self.validate_not_having_children(header, count = nil)
          raise ArgumentError, "Invalid Header Format. <%s>'s children are found. <%s> should have no children." % [ header.name, header.name ] if !header.children.nil? and header.children.any?
          true
        end

        def self.validate_not_having_grand_children(header)
          header.children.each { |child|
            raise ArgumentError, 'Invalid Header Format. <%s> should have no grand children.' % [ header.name ] if child.children.any?
          }
          true
        end
      end
    end
  end
end