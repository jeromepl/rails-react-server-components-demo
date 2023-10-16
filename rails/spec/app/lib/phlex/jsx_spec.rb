# frozen_string_literal: true

require "rails_helper"

require "stringio"
require "json"

RSpec.describe "JSX" do
  subject do
    output = StringIO.new.tap { |stream| TestComponent.new.call(stream:) }.string
    output.split("\n").map do |line|
      index, value = line.split(":", 2)
      [index.to_i, JSON.parse(value)]
    end
  end

  let(:test_component) do
    Class.new(Phlex::JSX) do
      def template
        div class: "Hi" do
          h1 { "This is a title" }
        end
      end
    end
  end

  before { stub_const("TestComponent", test_component) }

  it "renders correctly" do
    expect(subject).to eq(
      [
        [0, ["$", "div", nil, {
          "children" => [
            ["$", "h1", nil, {
              "children" => ["This is a title"]
            }]
          ],
          "class" => "Hi"
        }]]
      ]
    )
  end

  context "given an async component" do
    let(:test_component) do
      Class.new(Phlex::JSX) do
        def template
          div class: "Hi" do
            render AsyncComponent.new
          end
        end
      end
    end

    let(:async_component) do
      Class.new(Phlex::JSX) do
        include Phlex::JSX::AsyncRender

        def template
          sleep 0.3
          h1 { "This is a title" }
        end
      end
    end

    before { stub_const("AsyncComponent", async_component) }

    it "renders correctly" do
      expect(subject).to eq(
        [
          [1, ["$", "h1", nil, {
            "children" => ["This is a title"]
          }]],
          [0, ["$", "div", nil, {
            "children" => ["$L1"],
            "class" => "Hi"
          }]]
        ]
      )
    end
  end

  context "given many async components" do
    let(:test_component) do
      Class.new(Phlex::JSX) do
        def template
          div class: "Hi" do
            render FirstAsyncComponent.new
            render SecondAsyncComponent.new
          end
        end
      end
    end

    let(:first_async_component) do
      Class.new(Phlex::JSX) do
        include Phlex::JSX::AsyncRender

        def template
          sleep 0.1
          h1 { "This is a title" }
        end
      end
    end

    let(:second_async_component) do
      Class.new(Phlex::JSX) do
        include Phlex::JSX::AsyncRender

        def template
          sleep 0.1
          h2 { "This is a subtitle" }
        end
      end
    end

    before do
      stub_const("FirstAsyncComponent", first_async_component)
      stub_const("SecondAsyncComponent", second_async_component)
    end

    it "renders correctly" do
      expect(subject).to eq(
        [
          [1, ["$", "h1", nil, {
            "children" => ["This is a title"]
          }]],
          [2, ["$", "h2", nil, {
            "children" => ["This is a subtitle"]
          }]],
          [0, ["$", "div", nil, {
            "children" => ["$L1", "$L2"],
            "class" => "Hi"
          }]]
        ]
      )
    end
  end
end
