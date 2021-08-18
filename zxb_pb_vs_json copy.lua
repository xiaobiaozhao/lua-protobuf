local cjson_safe = require "cjson.safe"
local json_encode_safe = cjson_safe.encode
local json_decode_safe = cjson_safe.decode
local pb = require "pb"
local protoc = require "protoc"
local struct = require "struct"

-- load schema from text (just for demo, use protoc.new() in real world)

--[==[
protoc:load [[
    syntax = "proto2"

   	message Phone {
   	   optional string n        = 1;
   	   optional int64  p = 2;
   	}
   	message Person {
   	   optional string n     = 1;
   	   optional int32  a      = 2;
   	   optional string ad  = 3;
   	   repeated Phone  c = 4;
   	} 

    message Person2 {
   	   optional string ad  = 3;
   	   repeated Phone  c = 4;
   	}
]]
]==]
protoc:load [[
    syntax = "proto3"

   	message Phone {
   	   string n        = 1;
   	   int64  p = 2;
   	}
   	message Person {
   	   string n     = 1;
   	   int32  a      = 2;
   	   string ad  = 3;
   	   repeated Phone  c = 4;
   	} 

    message Person2 {
   	   string ad  = 3;
   	   repeated Phone  c = 4;
   	}
]]

-- lua table data
local data = {
    n = "ilse",
    a = 18,
    ad = "xxxxxxxxxxxxxxxxxxxxx",
    c = {
        {n = "alice", p = 12312341234},
        {n = "bob", p = 45645674567}
    }
}

local n = 1000 * 1000
-- encode lua table data into binary format in lua string and return
ngx.update_time()
local s = ngx.now()
local bytes
for i = 1, n do
    bytes = pb.encode("Person", data)
end
ngx.update_time()
print("pb encode cost:", ngx.now() - s)
print("bytes len:", #bytes)
print(pb.tohex(bytes))
print(bytes)

-- and decode the binary data back into lua table
ngx.update_time()
local s = ngx.now()
local data2
for i = 1, n do
    data2 = pb.decode("Person", bytes)
end
ngx.update_time()
print("pb decode cost:", ngx.now() - s)
print(require "serpent".block(data2))

local data3 = pb.decode("Person2", bytes)
print(require "serpent".block(data3))

ngx.update_time()
local s = ngx.now()
local json_str
for i = 1, n do
    json_str = json_encode_safe(data)
end
ngx.update_time()
print("json encode cost:", ngx.now() - s)
print("json len:", #json_str)
print(json_str)
print(pb.tohex(json_str))

ngx.update_time()
local s = ngx.now()
for i = 1, n do
    local json_tab = json_decode_safe(json_str)
end
ngx.update_time()
print("json decode cost:", ngx.now() - s)

local data = {
    n = "ilse",
    a = 18,
    ad = "xxxxxxxxxxxxxxxxxxxxx",
    c = {
        {n = "alice", p = 12312341234},
        {n = "bob", p = 45645674567}
    }
}

ngx.update_time()
local s = ngx.now()
local struct_str
for i = 1, n do
    struct_str =
        struct.pack(
        "i2c0i8i2c0i2c0i8i2c0i8",
        #"ilse",
        "ilse",
        18,
        #"xxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxx",
        #"alice",
        "alice",
        12312341234,
        #"bob",
        "bob",
        45645674567
    )
end
ngx.update_time()
print("struct encode cost:", ngx.now() - s)
print("struct len:", #struct_str)

ngx.update_time()
local s = ngx.now()
local x
for i = 1, n do
    x = {struct.unpack("i2c0i8i2c0i2c0i8i2c0i8", struct_str)}
end
ngx.update_time()
print("struct decode cost:", ngx.now() - s)
print("struct len:", #struct_str)
print(json_encode_safe(x))

--["ilse",18,"xxxxxxxxxxxxxxxxxxxxx","alice",12312341234,"bob",45645674567,66]
