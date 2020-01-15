${jsonencode({
  "rules" : [ for index, table in tables :
    {
      "rule-type" = "selection",
      "rule-id" = "${index}",
      "rule-name" = "${index}",
      "object-locator" = {
          "schema-name" = "%",
          "table-name" = "${table}"
      }
      "rule-action" = "include"
    }
  ]
})}
