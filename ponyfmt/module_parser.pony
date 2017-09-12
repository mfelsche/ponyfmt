use "ponycc/ast"
use "ponycc/ast/parse"
use "ponycc/frame"
use "ponycc/pass/post_parse"
use "ponycc/pass/syntax"

use "promises"

actor ModuleParser
  """
  """

  be parseModule(
    source: Source,
    errorHandler: {(Array[(String, SourcePosAny)] box)} val,
    moduleHandler: {(Module)} val)
  =>
    let errs = Array[(String, SourcePosAny)]
    let module =
      try
        Parse(source, errs)?
      else
        errorHandler(errs)
        return
      end
    FrameRunner[PostParse](module,
      {(ppModule: Module, errs: Array[(String, SourcePosAny)] val)(errorHandler, moduleHandler) =>
        if errs.size() > 0 then
          errorHandler(errs)
          return
        end
        FrameRunner[Syntax](ppModule,
          {(sModule: Module, errs: Array[(String, SourcePosAny)] val) =>
            if errs.size() > 0 then
              errorHandler(errs)
              return
            end
            moduleHandler(sModule)
          } val)
      } val)
