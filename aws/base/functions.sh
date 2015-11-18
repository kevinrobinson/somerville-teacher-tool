function extract_field {
  node -e "console.log(JSON.parse(process.argv[1])['$2'])" $1
}
