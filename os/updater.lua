-- URLs for the GitHub version file and files to update
local versionUrl = "https://raw.githubusercontent.com/GamerboyRyan/ComputerCraft-OS/main/version.txt"
local updaterUrl = "https://pastebin.com/vX7AD0wu"

-- Function to read the local version file
local function getLocalVersion()
    if fs.exists("currentVersion.txt") then
        local file = fs.open("currentVersion.txt", "r")
    
        local version = file.readLine()
    
        file.close()
    
        return version
    else
        return nil
    end
end

-- Function to get the latest version from GitHub
local function getRemoteVersion()
    local response = http.get(versionUrl)
  
    if response then
        local version = response.readLine()
    
        response.close()
    
        return version
    else
        print("Failed to check for updates. Ensure HTTP is enabled.")
    
        return nil
    end
end

-- Main update function
local function checkForUpdates()
    print("Checking for updates...")

    local localVersion = getLocalVersion()
    local remoteVersion = getRemoteVersion()

    if not localVersion then
        print("Local version not found. Assuming update is needed.")
    elseif not remoteVersion then
        print("Could not determine the latest version. Aborting update.")
        return
    elseif localVersion == remoteVersion then
        print("Your system is up-to-date! (Version " .. localVersion .. ")")
        return
    else
        print("New version available: " .. remoteVersion .. " (Current: " .. localVersion .. ")")
    end

    -- Proceed with updating files
    print("Getting Updater content from Pastebin...")

    local content = shell.run("pastebin get vX7AD0wu")
    
    print("Creating Updater file...")

    local updaterFile = fs.open("update.lua", "w")

    file.write(content)

    file.close()

    -- Update version file last
    local file = fs.open("currentVersion.txt", "w")
  
    file.write(remoteVersion)
  
    file.close()

    print("Update complete! System is now at version " .. remoteVersion)
end

-- Run the update check
checkForUpdates()
