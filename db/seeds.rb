# frozen_string_literal: true

languages = [
  { code: "en", name: "english"},
  { code: "pl", name: "polish" },
  { code: "de", name: "german" }
]

languages.each do |language|
  Language.find_or_create_by!(**language)
end
