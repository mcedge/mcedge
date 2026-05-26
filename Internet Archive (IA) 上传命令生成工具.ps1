Write-Host "==============================================================" -ForegroundColor Green
Write-Host "         Internet Archive (IA) 上传命令生成工具" -ForegroundColor Green
Write-Host "==============================================================" -ForegroundColor Green
Write-Host ""

# 1. 代理端口
$ProxyPort = Read-Host "【1/10】请输入代理端口"
if ([string]::IsNullOrWhiteSpace($ProxyPort)) { exit }

# 2. URL 后缀
$PageURL = Read-Host "【2/10】请输入网页 URL 后缀 (Page URL)"
if ([string]::IsNullOrWhiteSpace($PageURL)) { exit }
$CleanURL = $PageURL.Replace(" ", "-").ToLower() # 自动清洗 URL

# 3. 万能路径输入（支持文件/文件夹混搭）
Write-Host "【3/10】请输入要上传的路径 (支持单个文件、多个文件、或整个文件夹)：" -ForegroundColor Cyan
Write-Host "       (提示：输完一个路径按回车，全部输完后直接按回车结束)" -ForegroundColor Yellow
$PathArray = @()
while ($true) {
    $TempPath = Read-Host "       ↳ 请输入路径 (例如 D:\1 (文件夹) 或 D:\file.txt (文件)"
    if ([string]::IsNullOrWhiteSpace($TempPath)) { break }
    $CleanPath = $TempPath.Replace('"', '') # 自动去掉可能多复制的双引号
    $PathArray += "`"$CleanPath`""
}
if ($PathArray.Count -eq 0) { exit }
$FinalPaths = $PathArray -join " "

# 4. Collection 集合多选菜单（新）
Write-Host "【4/10】请选择存放的 Collection 集合 (输入数字后回车)：" -ForegroundColor Cyan
Write-Host "       1. Community movies (社区视频) --metadata=`"collection:opensource_movies`""
Write-Host "       2. Community audio (社区音频) --metadata=`"collection:opensource_audio`""
Write-Host "       3. Community texts (社区文本/图书) --metadata=`"collection:opensource_media`""
Write-Host "       4. Community software (社区软件/系统镜像) --metadata=`"collection:opensource_software`""
Write-Host "       5. Community image (社区图片) --metadata=`"collection:opensource_image`""
Write-Host "       6. Community data (社区数据/其他) --metadata=`"collection:community`""
$CollChoice = Read-Host "       你的选择"
switch ($CollChoice) {
    "1" { $Collection = "opensource_movies" }
    "2" { $Collection = "opensource_audio" }
    "3" { $Collection = "opensource_media" }
    "4" { $Collection = "opensource_software" }
    "5" { $Collection = "opensource_image" }
    "6" { $Collection = "community" }
    default { 
        if ([string]::IsNullOrWhiteSpace($CollChoice)) { exit } else { $Collection = $CollChoice }
    }
}

# 5. 网页大标题
$Title = Read-Host "【5/10】请输入项目标题(Item Title)"
if ([string]::IsNullOrWhiteSpace($Title)) { exit }

# 6. 简介描述
$Desc = Read-Host "【6/10】请输入该项目的简单介绍描述(Description)"
if ([string]::IsNullOrWhiteSpace($Desc)) { exit }

# 7. 标签自由手填
$Tags = Read-Host "【7/10】请输入检索标签(Subject Tags)多个标签请用英文分号 ; 隔开"
if ([string]::IsNullOrWhiteSpace($Tags)) { exit }

# 8. 创建者手填
$Creator = Read-Host "【8/10】请输入创建者/作者 (Creator)"
if ([string]::IsNullOrWhiteSpace($Creator)) { exit }

# 9. 语言手填（这次真的回来了！）
$Language = Read-Host "【9/10】请输入项目语言 (如 Chinese, English, Japanese)"
if ([string]::IsNullOrWhiteSpace($Language)) { exit }

# 10. 日期手填
$Date = Read-Host "【10/10】请输入发布日期 (格式: 2026-05-22)"
if ([string]::IsNullOrWhiteSpace($Date)) { exit }


$FinalCommand = "`$env:HTTP_PROXY='http://127.0.0.1:$ProxyPort'; `$env:HTTPS_PROXY='http://127.0.0.1:$ProxyPort'; ia upload $CleanURL $FinalPaths --metadata=`"title:$Title`" --metadata=`"collection:$Collection`" --metadata=`"description:$Desc`" --metadata=`"subject:$Tags`" --metadata=`"creator:$Creator`" --metadata=`"date:$Date`" --metadata=`"language:$Language`" --metadata=`"licenseurl:http://creativecommons.org/publicdomain/zero/1.0/`" --checksum"

Write-Host ""
Write-Host "======================= ✨ 生成成功 脚本作者:Gemini✨ =======================" -ForegroundColor Green
Write-Host "请直接鼠标刮选复制下方整行命令，粘贴到新窗口中回车执行：" -ForegroundColor Cyan
Write-Host ""
Write-Host $FinalCommand -ForegroundColor White
Write-Host ""
Write-Host "=============================================================================" -ForegroundColor Green
Write-Host ""

# 拦截窗口，防止闪退
Read-Host "检查无误后，按 [回车键] 退出此窗口..."