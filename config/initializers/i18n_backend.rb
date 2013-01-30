# Adding Redis backend to the I18n translations and use as default the(YAML) backend
TRANSLATION_STORE = Redis.new
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(TRANSLATION_STORE), I18n.backend)