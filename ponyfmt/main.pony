use "ponycc/ast"
use "cli"
use "files"
use "ponycc/ast/print"

actor Main
  let env: Env

  new create(env': Env) =>
    env = env'
    let commandSpec =
      try
        CommandSpec.leaf(
          "ponyfmt",
          "A Pony Code Formatter",
          [
            OptionSpec.string("output", "Output directory", 'o', ".")],
          [
            ArgSpec.string_seq("modules", "The pony modules to format")
          ])? .> add_help()?
      else
        env'.err.print("Invalid CommandSpec")
        env'.exitcode(1)
        return
      end
    let cmd =
      match CommandParser(commandSpec).parse(env.args, env.vars())
      | let c: Command => c
      | let ch: CommandHelp =>
        ch.print_help(env.out)
        env'.exitcode(0)
        return
      | let se: SyntaxError =>
        env'.err.print(se.string())
        env'.exitcode(1)
        return
      end

    let modules = cmd.arg("modules").string_seq()
    for modulePath in modules.values() do
      formatModule(modulePath)
    end

  fun box reportErrors(errs: Array[(String, SourcePosAny)]) =>
    """
    """

  fun formatModule(modulePath: String) =>
    let moduleSource: Source =
      try
        loadModule(modulePath)?
      else
        env.err.print("unable to load module @ " + modulePath)
        return
      end
    ModuleParser.parseModule(
      moduleSource,
      {(errs: Array[(String, SourcePosAny)] box) =>
        env.err.print(modulePath)
        for err in errs.values() do
          (let line, let arrow) = err._2.show_in_line()
          env.err
            .>print("  ERROR:")
            .>print("    " + err._1)
            .>print("    " + line)
            .>print("    " + arrow)
            .>print("")
        end
      } val,
      {(module: Module) =>
        // TODO: use Formatter
        env.out
          .>print(modulePath)
          .>print(Print(module))
      } val)



  fun loadModule(path: String): Source ? =>
    let filePath = FilePath(env.root as AmbientAuth, path)?
    match OpenFile(filePath)
    | let file: File =>
      Source(file.read_string(file.size()), path)
    else
      error
    end
