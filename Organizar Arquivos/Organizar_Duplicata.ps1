function Get-Path { param ()
    $folderPath = Read-Host "Por favor, insira o caminho da pasta que deseja usar"
    if (-not (Test-Path -Path $folderPath) -or (Get-Item $folderPath).PSIsContainer -eq $false) {
        Write-Host "O caminho fornecido não é uma pasta válida. Por favor, tente novamente." -ForegroundColor Red
        return Get-Path
    }
    elseif ((Get-ChildItem -Path $folderPath -Recurse -File).Count -eq 0) {
        Write-Host "A pasta fornecida não contém arquivos. Por favor, escolha outra pasta." -ForegroundColor Yellow
        return Get-Path
    } 
    Write-Host "Você escolheu a pasta: $folderPath" -ForegroundColor Green
    return Get-ChildItem -Path $folderPath -Recurse -File;
}

function Test-DuasPastas {param ()
    $verificacao = Read-Host "Você deseja verificar duas pastas? (S/N)"
    if ($verificacao.ToUpper() -eq "S") {
        return $true
    } else {
        return $false
    }
}

function Get-option {
    param ()
    $verificacao = Read-Host "Digite R para remover, V para verificar ou M para mover os arquivos encontrados"
    switch ($verificacao.ToUpper()) {
        "V" { 
            Write-Host "Você escolheu a opção: Verificar" -ForegroundColor Green
            return 0 
        }
        "M" { 
            Write-Host "Você escolheu a opção: Mover" -ForegroundColor Yellow
            return 1 
        }
        "R" { 
            Write-Host "Você escolheu a opção: Remover" -ForegroundColor Red
            return 2 
        }
        default {
            Write-Host "Opção inválida. Por favor, escolha R, V ou M." -ForegroundColor DarkRed
            return Get-option
        }
    }
}

function Invoke-Arquivos { param ($files,$fileHashes,$option)
    foreach ($file in $files) {
        $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
        $hashValue = $hash.Hash
        try {
            if ($fileHashes.ContainsKey($hashValue)) {
                Test-Documento -file $file -fileHashes $fileHashes -hashValue $hashValue -option $option
            } 
            else {
                $fileHashes[$hashValue] = $file
                Write-Host "Arquivo diferente $($file.FullName)" -ForegroundColor Magenta
             }    
        }
        catch {
            Write-Warning "Erro ao processar o arquivo: $($file.FullName). Detalhes: $($_.Exception.Message)"
        }
    }
}

function Test-Documento {param ($file, $fileHashes, $hashValue, $option)
    If($file.LastWriteTime -ge $fileHashes[$hashValue].LastWriteTime -and 
        $file.Length -eq $fileHashes[$hashValue].Length){
            Select-Choosed -file $fileHashes[$hashValue] -file_duplicata $file -option $option -color "Red"
    }
    elseif ($file.LastWriteTime -lt $fileHashes[$hashValue].LastWriteTime -and 
        $file.Length -eq $fileHashes[$hashValue].Length) {
            Select-Choosed -file $file -file_duplicata $fileHashes[$hashValue] -option $option -color "DarkCyan"
            $fileHashes[$hashValue] = $file
    }
    else {
        Write-Host "Arquivo não identificado como duplicata ou diferente: $($file.FullName)" -ForegroundColor Blue
    }
}
function Select-Choosed {param ($file, $file_duplicata, $option, $color)
    if($option -eq 0) {
        Show-DuplicataMessage -file $file -file_duplicata $file_duplicata -color $color
    }
    elseif($option -eq 1) {
        Show-DuplicataMessage -file $file -file_duplicata $file_duplicata -color $color
        Move-Duplicata -filePath $file_duplicata.FullName -destinationPath  "D:\Duplicata"
    }
    elseif ($option -eq 2) {
        Show-DuplicataMessage -file $file -file_duplicata $file_duplicata -color $color
        Remove-Duplicata -filePath $file_duplicata.FullName
    }
    else {
        Write-Host "Opção inválida. Nenhuma ação será realizada." -ForegroundColor Yellow
    }
}

# Função para criar diretório e mover arquivo
function Move-Duplicata { param ($filePath,$destinationPath)
    try {
        if (-not (Test-Path -Path $destinationPath)) {
            New-Item -ItemType Directory -Path $destinationPath | Out-Null
        }
        Move-Item -Path $filePath -Destination $destinationPath  
    }
    catch {
            Write-Warning "Erro ao mover o arquivo: $($filePath). Detalhes: $($_.Exception.Message)"
    }
}

function Remove-Duplicata {param ($filePath)
    try {
        Remove-Item -Path $filePath -Force
    }
    catch {
        Write-Warning "Erro ao remover o arquivo: $($filePath). Detalhes: $($_.Exception.Message)"
    }
}

function Show-DuplicataMessage {param ($file, $file_duplicata, $color)
    Write-Host "Duplicata encontrada: $($file_duplicata.FullName) - $($file_duplicata.LastWriteTime) - $($file_duplicata.Length) é duplicata de $($file.FullName) $($file.LastWriteTime) - $($file.Length)" -ForegroundColor $color
}





# Caminho da pasta para verificar duplicatas
Clear-Host
Write-Host "A tela foi limpa! Executando comandos..." -ForegroundColor Cyan

$fileHashes = @{}

if(Test-DuasPastas){

    Invoke-Arquivos -files (Get-Path) -fileHashes $fileHashes  -option (Get-option)
    Invoke-Arquivos -files (Get-Path) -fileHashes $fileHashes  -option (Get-option)
}
else {
    Invoke-Arquivos -files (Get-Path) -fileHashes $fileHashes  -option (Get-option)
}

Write-Host "Organizacao concluida!" -ForegroundColor Green 
