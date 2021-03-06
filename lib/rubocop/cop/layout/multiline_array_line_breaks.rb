# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # This cop ensures that each item in a multi-line array
      # starts on a separate line.
      #
      # @example
      #
      #   # bad
      #   [
      #     a, b,
      #     c
      #   ]
      #
      #   # good
      #   [
      #     a,
      #     b,
      #     c
      #   ]
      class MultilineArrayLineBreaks < Cop
        include MultilineElementLineBreaks

        MSG = 'Each item in a multi-line array must start ' \
          'on a separate line.'.freeze

        def on_array(node)
          check_line_breaks(node, node.children)
        end

        def autocorrect(node)
          EmptyLineCorrector.insert_before(node)
        end
      end
    end
  end
end
