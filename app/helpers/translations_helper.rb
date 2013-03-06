module TranslationsHelper
  def tokenize key
    key_array = key.split('.')
    return key_array.first, key_array[1..key_array.size].join('.')
  end
  
end
