module I18n
  class MissingTranslation
    def html_message
      key = keys.last.to_s.gsub('_', ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
      %(<span class="translation_missing" title="translation missing: #{keys.join('.')}">
          #{keys.join('.')}
          <a href=/translations/> >> </a>
        </span>)
    end
  end
end


# Adding Redis backend to the I18n translations and use as default the(YAML) backend
TRANSLATION_STORE = Redis.new
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(TRANSLATION_STORE), I18n.backend)

