local cjson_safe = require "cjson.safe"
local json_encode_safe = cjson_safe.encode
local json_decode_safe = cjson_safe.decode
local pb = require "pb"
local protoc = require "protoc"
local struct = require "struct"

-- load schema from text (just for demo, use protoc.new() in real world)

protoc:load [[
    syntax = "proto3"

    message DV_ZD_3 {
        string	u1	=	1;	//	ack
        string	v1	=	2;	//	DVID
        string	v2	=	3;	//	token
        string	d78	=	4;	//	uuid
        string	d15	=	5;	//	os
        int32	d39	=	6;	//	电量
        int32	d601	=	7;	//	剩余可用内存
        string	d29	=	8;	//	SSID
        bool	d54	=	9;	//	USB
        string	n1	=	10;	//	内网 IP
        string	n4	=	11;	//	网关 IP
        int32	d30	=	12;	//	网络类型
        float	d33	=	13;	//	屏幕亮度
        string	d24	=	14;	//	音量
        int32	d40	=	15;	//	充电状态, empty = -1
        int32	d51	=	16;	//	SIM 状态
        uint64	a9	=	17;	//	当前 APP 安装时间
        string	d76	=	18;	//	分辨率
        bool	d602	=	19;	//	省电模式
        uint64	d8	=	20;	//	磁盘可用空间
        int32	d603	=	21;	//	wifi/4G/5G 信号强度
        int32	c1	=	22;	//	root
        int32	c3	=	23;	//	hook
        int32	C10	=	24;	//	emulator
        bool	c8	=	25;	//	debug
        bool	c9	=	26;	//	MultRun
        int32	c201	=	27;	//	root
        int32	c203	=	28;	//	hook
        bool    c208	=	29;	//	debug
        bool	d44	=	30;	//	VPN
        string	d16	=	31;	//	系统版本
        string	d42	=	32;	//	手机品牌
        uint64	d94	=	33;	//	本地时间戳
    }
]]

protoc:load [[
syntax = "proto2";
 
message DV_ZD_2 {
    optional string	event_name	=	1;	// 事件名	
    optional int32	type	=	2;	// 0:自动 1:手动	
    optional string	source	=	3;	// a/i/aj/ij  a表示nativeAndroid，i表示nativeiOS，aj表示js调用Android，ij表示js调用iOS
    optional string	ptt	=	4;	//	uint32取 uint32 随机数，设置种子为当前时间戳(毫秒)
    optional string	index	=	5;	// 埋点的索引
    optional string	page_index	=	6;	//	页面索引
    optional string	page_name	=	7;	//	
    optional string	page_title	=	8;	//	
    optional string	pre_page_name	=	9;	//	
    optional string	pre_page_title	=	10;	//	
    optional int32	net	=	11;	//	
    optional int32	bluetooth	=	12;	//	
    optional uint64	APP_duration	=	13;	//	
    optional uint64	page_duration	=	14;	//	
    optional string	u1	=	20;	//	ack
    optional string	v1	=	21;	//	DVID
    optional string	v2	=	22;	//	token
    optional string	d78	=	23;	//	uuid
    optional string	d15	=	24;	//	os
    optional int32	d39	=	25;	//	电量
    optional int32	d601	=	26;	//	剩余可用内存
    optional string	d29	=	27;	//	SSID
    optional bool	d54	=	28;	//	USB
    optional string	n1	=	29;	//	内网 IP
    optional string	n4	=	30;	//	网关 IP
    optional int32	d30	=	31;	//	网络类型
    optional float	d33	=	32;	//	屏幕亮度
    optional string	d24	=	33;	//	音量
    optional int32	d40	=	34;	//	充电状态, empty = -1
    optional int32	d51	=	35;	//	SIM 状态
    optional uint64	a9	=	36;	//	当前 APP 安装时间
    optional string	d76	=	37;	//	分辨率
    optional bool	d602	=	38;	//	省电模式
    optional uint64	d8	=	39;	//	磁盘可用空间
    optional int32	d603	=	40;	//	wifi/4G/5G 信号强度
    optional int32	c1	=	41;	//	root
    optional int32	c3	=	42;	//	hook
    optional int32	C10	=	43;	//	emulator
    optional bool	c8	=	44;	//	debug
    optional bool	c9	=	45;	//	MultRun
    optional int32	c201	=	46;	//	root
    optional int32	c203	=	47;	//	hook
    optional bool   c208	=	48; //	debug	
    optional bool	d44	=	49;	//	VPN
    optional string	d16	=	50;	//	系统版本
    optional string	d42	=	51;	//	手机品牌
    optional uint64	d94	=	52;	//	本地时间戳
    optional uint64	d604	=	53;		
    optional uint64	d605	=	54;		
}
]]
local data = {
    --u1 = "xxxxxxxxxxxxxxxxxxxx",
    --v1 = "DD_xxxxxxxxxxxxxxxxxx",
    d94 = 1234567890123,
    c1 = 1,
    c10 = 0
}

local n = 1000 * 1000

-- protobuf 3
ngx.update_time()
local s = ngx.now()
local byte
for i = 1, n do
    byte = pb.encode("DV_ZD_3", data)
end
ngx.update_time()
print("pb encode 3 cost:", ngx.now() - s)
print(pb.tohex(byte))

local byte = pb.encode("DV_ZD_3", data)
ngx.update_time()
local s = ngx.now()
local data_t
for i = 1, n do
    data_t = pb.decode("DV_ZD_3", byte)
end
ngx.update_time()
print("pb decode 3 cost:", ngx.now() - s)
print(require "serpent".block(data_t))

-- protobuf 2
ngx.update_time()
local s = ngx.now()
local byte
for i = 1, n do
    byte = pb.encode("DV_ZD_2", data)
end
ngx.update_time()
print("pb encode 2 cost:", ngx.now() - s)
print(pb.tohex(byte))

local byte = pb.encode("DV_ZD_2", data)
local n = 1000 * 1000
ngx.update_time()
local s = ngx.now()
local data_t
for i = 1, n do
    data_t = pb.decode("DV_ZD_2", byte)
end
ngx.update_time()
print("pb decode 2 cost:", ngx.now() - s)
print(require "serpent".block(data_t))
