# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Style::YodaCondition do
  subject(:cop) { described_class.new }
  subject(:error_message) { described_class::MSG }

  before { inspect_source(cop, source) }

  shared_examples 'accepts' do |code|
    let(:source) { code }

    it 'does not register an offense' do
      expect(cop.offenses).to be_empty
    end
  end

  shared_examples 'offense' do |code|
    let(:source) { code }

    it "registers an offense for #{code}" do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message).to(
        eq(format(error_message, code))
      )
    end
  end

  shared_examples 'autocorrect' do |code, corrected|
    let(:source) { code }
    it 'autocorrects code' do
      expect(autocorrect_source(cop, source)).to eq(corrected)
    end
  end

  it_behaves_like 'accepts', 'foo == "bar"'
  it_behaves_like 'accepts', 'foo[0] > "bar" || baz != "baz"'
  it_behaves_like 'accepts', 'node = last_node.parent'
  it_behaves_like 'accepts', '(first_line - second_line) > 0'

  it_behaves_like 'offense', '"foo" == bar'
  it_behaves_like 'offense', 'nil == bar'
  it_behaves_like 'offense', 'false == active?'
  it_behaves_like 'offense', '15 != @foo'
  it_behaves_like 'offense', '42 < bar'

  context 'autocorrection' do
    it_behaves_like(
      'autocorrect', 'if 10 == my_var; end', 'if my_var == 10; end'
    )

    it_behaves_like(
      'autocorrect', 'if 2 < bar;end', 'if bar > 2;end'
    )

    it_behaves_like(
      'autocorrect', 'foo = 42 if 42 > bar', 'foo = 42 if bar < 42'
    )

    it_behaves_like(
      'autocorrect', '42 <= foo ? bar : baz', 'foo >= 42 ? bar : baz'
    )

    it_behaves_like(
      'autocorrect', '42 >= foo ? bar : baz', 'foo <= 42 ? bar : baz'
    )

    it_behaves_like(
      'autocorrect', 'nil != foo ? bar : baz', 'foo != nil ? bar : baz'
    )

    it_behaves_like(
      'autocorrect', 'false === foo ? bar : baz', 'foo === false ? bar : baz'
    )
  end
end
