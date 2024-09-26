﻿# Taken from https://powershell.one/powershell-internals/parsing-and-tokenization/abstract-syntax-tree
function Convert-CodeToAst
{
  param
  (
    [Parameter(Mandatory)]
    [ScriptBlock]
    $code
  )


  # build a hashtable for parents
  $hierarchy = @{}

  $code.Ast.FindAll( { $true }, $true) |
  ForEach-Object {
    # take unique object hash as key
    $id = $_.Parent.GetHashCode()
    if ($hierarchy.ContainsKey($id) -eq $false)
    {
      $hierarchy[$id] = [System.Collections.ArrayList]@()
    }
    $null = $hierarchy[$id].Add($_)
    # add ast object to parent

  }

  # visualize tree recursively
  function Visualize-Tree {
    param(
      $id,
      $indent = 0
    )
    # use this as indent per level:
    $space = '--' * $indent
    $hierarchy[$id] | ForEach-Object {
      # output current ast object with appropriate
      # indentation:
      '{0}[{1}]: {2}' -f $space, $_.GetType().Name, $_.Extent

      # take id of current ast object
      $newid = $_.GetHashCode()
      # recursively look at its children (if any):
      if ($hierarchy.ContainsKey($newid))
      {
        Visualize-Tree -id $newid -indent ($indent + 1)
      }
    }
  }

  # start visualization with ast root object:
  Visualize-Tree -id $code.Ast.GetHashCode()
}

Convert-CodeToAst -Code {
 #### Write your code to render in ast type here ####
 $private:bob = "oui"
}
