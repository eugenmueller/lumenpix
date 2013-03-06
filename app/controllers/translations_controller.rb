
require 'active_support/core_ext/hash/deep_merge'

class TranslationsController < ApplicationController
  def index
    @locales = locales 
    @translations = TRANSLATION_STORE
    all_keys = @translations.keys.collect{|key| key.split('.')[1..-1].join('.')}
    @translation_keys = all_keys.uniq
  end

  def new
    @locales = locales
  end

  def show
    redirect_to translations_url
  end

  def create
    I18n.backend.store_translations(params[:locale], 
      {params[:key] => params[:value].to_s}, :escape => false)
    redirect_to translations_url, :notice => t("notice.translations.added_translations")
  end

  def destroy
    TRANSLATION_STORE.del(params[:key].to_s)
    redirect_to translations_url, :notice => t("notice.translations.deleted_translation")
  end

  def write_to_yaml
    
    locales.each do |locale|
      #yaml_file = YAML.load_file("#{Rails.root}/config/locales/#{locale.to_s}.yml")
      h = {}
      TRANSLATION_STORE.keys("#{locale}.*").each do |key|
        h = add_translation(h, key)
      end
      
      File.open("#{Rails.root}/config/locales/#{locale.to_s}.yml", 'w:ASCII-8BIT'){|f| YAML.dump(h, f) }
    end
    redirect_to translations_url
  end

  #TODO read_from_yaml
  def read_from_yaml
  end

  private

  def locales
    locales ||= I18n.backend.available_locales 
  end

  def add_translation(yaml_hash, key)
    # generate a hash from the Redis store
    value = ActiveSupport::JSON.decode(TRANSLATION_STORE[key]).to_a.first
    new_hash = key.split('.').reverse.inject(value) {|a, n| {n => a}}
    # merge with the existing hash
    return yaml_hash.deep_merge(new_hash)
  end

end
