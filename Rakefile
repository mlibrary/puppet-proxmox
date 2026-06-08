# frozen_string_literal: true

require 'voxpupuli/test/rake/puppetlint'
require 'voxpupuli/test/rake/puppetsyntax'
require 'voxpupuli/test/rake/spec'
require 'voxpupuli/test/rake/validate'

# task test: %i[lint validate standard fixtures:prep ci:spec]
task test: %i[lint validate fixtures:prep parallel_spec:standalone]

task default: [:test]
