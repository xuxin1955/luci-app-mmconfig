require("nixio.fs")

local m
local s
local mode2g = os.execute("/usr/share/modeminfo/scripts/getmode.sh 2g")
local mode3g = os.execute("/usr/share/modeminfo/scripts/getmode.sh 3g")
local mode4g = os.execute("/usr/share/modeminfo/scripts/getmode.sh 4g")

m = Map("modemconfig", translate("配置调制解调器频段"),
    translate("配置 2G/3G/4G 调制解调器的频率频段。"))

s = m:section(TypedSection, "modem", "<p>&nbsp;</p>" .. translate("选择蜂窝调制解调器频段"))
s.anonymous = true
s.description = translate("请根据你的 SIM 卡和运营商支持情况选择频段。")

-- 2G
if mode2g == 0 then
    s:option(DummyValue, "_2g_h", "").description =
        "<strong>2G</strong> <small>移动/联通：GSM900 / 1800</small>"
    gsm = s:option(StaticList, "gsm_band", "")
    gsm:value("8", "GSM900")
    gsm:value("3", "GSM1800")
    gsm.rmempty = true
end

-- 3G
if mode3g == 0 then
    s:option(DummyValue, "_3g_h", "").description =
        "<strong>3G</strong> <small>联通：WCDMA850 / 900 / 2100</small>"
    wcdma = s:option(StaticList, "3g_band", "")
    wcdma:value("9", "WCDMA850")
    wcdma:value("8", "WCDMA900")
    wcdma:value("1", "WCDMA2100")
    wcdma.rmempty = true
end

-- 4G FDD
if mode4g == 0 then
    s:option(DummyValue, "_4g_fdd_h", "").description =
        "<strong>4G FDD</strong> <small>联通：B1 / B3（主力），B7 / B8；电信：B1 / B3 / B5（主力），B8 / B20</small>"

    ltefdd = s:option(StaticList, "lte_band_fdd", "")
    ltefdd:value("1", "B1")
    ltefdd:value("3", "B3")
    ltefdd:value("5", "B5")
    ltefdd:value("7", "B7")
    ltefdd:value("8", "B8")
    ltefdd:value("20", "B20")
    ltefdd.rmempty = true

-- 4G TDD
    s:option(DummyValue, "_4g_tdd_h", "").description =
        "<strong>4G TDD</strong> <small>移动主力：B38 / B40 / B41</small>"

    ltetdd = s:option(StaticList, "lte_band_tdd", "",
        translate("可能需要重新连接蜂窝网络接口。<br />如果取消选中所有频段，则使用调制解调器默认配置。"))
    ltetdd:value("38", "B38")
    ltetdd:value("40", "B40")
    ltetdd:value("41", "B41")
    ltetdd.rmempty = true
end

function m.on_after_commit(Map)
    luci.sys.call("/usr/bin/modemconfig")
end

return m
