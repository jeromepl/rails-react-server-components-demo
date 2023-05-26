class Dsl
  def perform
    container do
      button do
        typography text: "Confirm"
      end
    end
  end
end