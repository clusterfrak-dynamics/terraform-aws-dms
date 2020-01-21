${jsonencode({
  "rules" : [ for index, table in tables :
    {
      "rule-type" = "selection",
      "rule-id" = "${index + 1}",
      "rule-name" = "${index + 1}",
      "object-locator" = {
          "schema-name" = "%",
          "table-name" = "${table}"
      }
      "rule-action" = "include"
    }
  ]
})}
