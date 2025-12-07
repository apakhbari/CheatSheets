function add_identifier(tag, timestamp, record)
    -- Get server identifier from environment variable
    local server_id = os.getenv("SERVER_IDENTIFIER") or "unknown"
    
    -- Expecting tag format: docker.container_name
    -- We split the tag to get the container name
    local container_name = "unknown"
    
    -- The tag comes in as "docker.my-app". We want "my-app"
    local p1, p2 = tag:match("([^.]+).([^.]+)")
    if p2 then
        container_name = p2
    end

    -- Docker's fluentd driver automatically adds these fields to the log record.
    -- Setting them to 'nil' removes them before the record is sent to GELF.
    record["container_id"] = nil


    -- Create the custom field using environment variable
    record["identifier"] = server_id .. ":" .. container_name
    
    -- Ensure the 'log' key exists for GELF
    if record["log"] == nil and record["message"] ~= nil then
        record["log"] = record["message"]
    end

    return 1, timestamp, record
end