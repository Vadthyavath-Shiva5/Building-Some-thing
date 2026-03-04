param(
  [int]$Port = 5173
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$prefix = "http://localhost:$Port/"

function Get-ContentType([string]$path) {
  switch ([IO.Path]::GetExtension($path).ToLowerInvariant()) {
    ".html" { return "text/html; charset=utf-8" }
    ".css"  { return "text/css; charset=utf-8" }
    ".js"   { return "text/javascript; charset=utf-8" }
    ".json" { return "application/json; charset=utf-8" }
    ".png"  { return "image/png" }
    ".jpg"  { return "image/jpeg" }
    ".jpeg" { return "image/jpeg" }
    ".svg"  { return "image/svg+xml" }
    default { return "application/octet-stream" }
  }
}

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($prefix)
$listener.Start()

Write-Host "Serving $root at $prefix"
Write-Host "Press Ctrl+C to stop."

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response

    try {
      $urlPath = $req.Url.AbsolutePath
      if ([string]::IsNullOrWhiteSpace($urlPath) -or $urlPath -eq "/") {
        $urlPath = "/index.html"
      }

      $urlPath = [Uri]::UnescapeDataString($urlPath)
      $urlPath = $urlPath -replace "/", "\"

      $candidate = Join-Path $root ($urlPath.TrimStart("\"))
      $fullPath = [IO.Path]::GetFullPath($candidate)

      if (-not $fullPath.StartsWith([IO.Path]::GetFullPath($root), [StringComparison]::OrdinalIgnoreCase)) {
        $res.StatusCode = 400
        $bytes = [Text.Encoding]::UTF8.GetBytes("Bad request")
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.Close()
        continue
      }

      if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        $res.StatusCode = 404
        $bytes = [Text.Encoding]::UTF8.GetBytes("Not found")
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.Close()
        continue
      }

      $res.StatusCode = 200
      $res.ContentType = Get-ContentType $fullPath
      $fileBytes = [IO.File]::ReadAllBytes($fullPath)
      $res.ContentLength64 = $fileBytes.Length
      $res.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
      $res.Close()
    } catch {
      try {
        $res.StatusCode = 500
        $bytes = [Text.Encoding]::UTF8.GetBytes("Server error")
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.Close()
      } catch { }
    }
  }
} finally {
  $listener.Stop()
  $listener.Close()
}

