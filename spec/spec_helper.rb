# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "tjson"
require "support/example_loader"

RSpec.configure(&:disable_monkey_patching!)
