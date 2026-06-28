-- CMake Build Type 状态栏显示插件
-- 利用 cmake-tools.nvim 的 API 获取构建类型，兼容性更好
-- 非 CMake 工程则不显示任何内容

local M = {}

-- 利用 cmake-tools 判断是否是 CMake 工程
function M.is_cmake_project()
	local ok, cmake = pcall(require, "cmake-tools")
	if not ok then
		return false
	end
	return cmake.is_cmake_project()
end

-- 利用 cmake-tools 获取 Build Type
-- cmake-tools 内部已处理 preset、session 恢复等逻辑
function M.get_build_type()
	local ok, cmake = pcall(require, "cmake-tools")
	if not ok then
		return nil
	end
	return cmake.get_build_type()
end

-- 返回 lualine 组件配置
function M.lualine_component()
	return {
		function()
			if not M.is_cmake_project() then
				return ""
			end
			local build_type = M.get_build_type()
			if not build_type then
				return "CMake:?"
			end
			-- Debug 用红色高亮，Release 用绿色高亮
			if build_type == "Debug" then
				return "%#DiagnosticError#CMake:Debug%*"
			elseif build_type == "Release" then
				return "%#DiagnosticOk#CMake:Release%*"
			elseif build_type == "RelWithDebInfo" then
				return "%#DiagnosticWarn#CMake:RelDebInfo%*"
			elseif build_type == "MinSizeRel" then
				return "%#DiagnosticHint#CMake:MinSizeRel%*"
			else
				return "CMake:" .. build_type
			end
		end,
		cond = function()
			return M.is_cmake_project()
		end,
	}
end

return M

