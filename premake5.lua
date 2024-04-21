workspace "Hazel"        	-- 解决方案名称
    architecture "x64"   
    
    configurations
    {
        "Debug",
        "Release",    
        "Dist"
    }
-- 输出路径变量：结构类似于 debug-windows-x64    
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"   

project "Hazel"         -- 项目名称
    location "Hazel"
    kind "SharedLib" 		-- DLL
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}") -- lua的字符串拼接方式 ..
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}") -- 编译中间产物存放路径
    
    files                                   -- 包含项目下所有的.h .cpp文件
    {
        "%{prj.name}/src/**.h",    
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include"
    }

    filter "system:windows" --对特定的系统(windows、OS..)、配置(Debug/Release)、平台(x64、x86)的项目属性
        cppdialect "C++17"  --C++特性版本
        staticruntime "On"  
        systemversion "latest"    -- windows SKD版本

        defines
        {
            "HZ_PLATFORM_WINDOWS",
            "HZ_BUILD_DLL"
        }

        postbuildcommands	-- 后构建命令，构建完毕后执行的操作
        {
            -- 拷贝本项目输出文件中的dll到指定文件夹中
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
        }

    filter "configurations:Debug"
        defines "HZ_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On" 

    filter "configurations:Dist"
        defines "HZ_DIST"
        optimize "On"
    -- 可以过滤多个选项，一起配置
    -- filter {"system:windows", "configurations:Release"}
    --     buildoptions "/MT"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
    
    files   -- 参与编译的文件
    {
        "%{prj.name}/src/**.h",    
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "Hazel/vendor/spdlog/include",
        "Hazel/src"
    }

    links        --链接库
    {
        "Hazel"
    }

    filter "system:windows" 
        cppdialect "C++17" 
        staticruntime "On"  
        systemversion "latest" 

        defines
        {
            "HZ_PLATFORM_WINDOWS"
        }

    filter "configurations:Debug"
        defines "HZ_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On" 

    filter "configurations:Dist"
        defines "HZ_DIST"
        optimize "On"
