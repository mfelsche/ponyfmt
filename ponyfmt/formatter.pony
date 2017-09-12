
class val FormatterConfig

actor Formatter
  let config: FormatterConfig

  new create(config': FormatterConfig) =>
    config = config'
