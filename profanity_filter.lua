-- Profanity Filter
-- Configuration

-- Command to use:
-- Can use mute, textban, b, ipban
COMMAND_TO_USE = "mute"

-- Time in minutes. Set to 0 to not do anything, just block messages.
ACTION_TIME = 0

-- Message to tell to the player for swearing. Set to "" to not send a message.
BAD_WORD_BLOCK = "Your message has been blocked for profanity."

-- Block these words. Separate with commas
BAD_WORDS = {
    "filter", "word", "list",
}

-- End of configuration
api_version = "1.6.0.0"
function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'],"OnMessage")
end
function OnScriptUnload() end
function OnMessage(PlayerIndex, Message)
    local msg_lowercase = string.lower(Message)
    for k,v in pairs(BAD_WORDS) do
        if(string.gsub(msg_lowercase,string.lower(v),"") ~= msg_lowercase) then
            if(ACTION_TIME > 0) then
                execute_command(COMMAND_TO_USE .. " " .. PlayerIndex .. " " .. ACTION_TIME)
                if(BAD_WORD_BLOCK ~= nil and BAD_WORD_BLOCK ~= "") then
                    say(PlayerIndex,BAD_WORD_BLOCK)
                end
            end
            return false
        end
    end
    return true
end