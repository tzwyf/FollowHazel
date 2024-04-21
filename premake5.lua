workspace "Hazel"        	-- �����������
    architecture "x64"   
    
    configurations
    {
        "Debug",
        "Release",    
        "Dist"
    }
-- ���·���������ṹ������ debug-windows-x64    
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"   

project "Hazel"         -- ��Ŀ����
    location "Hazel"
    kind "SharedLib" 		-- DLL
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}") -- lua���ַ���ƴ�ӷ�ʽ ..
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}") -- �����м������·��
    
    files                                   -- ������Ŀ�����е�.h .cpp�ļ�
    {
        "%{prj.name}/src/**.h",    
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include"
    }

    filter "system:windows" --���ض���ϵͳ(windows��OS..)������(Debug/Release)��ƽ̨(x64��x86)����Ŀ����
        cppdialect "C++17"  --C++���԰汾
        staticruntime "On"  
        systemversion "latest"    -- windows SKD�汾

        defines
        {
            "HZ_PLATFORM_WINDOWS",
            "HZ_BUILD_DLL"
        }

        postbuildcommands	-- �󹹽����������Ϻ�ִ�еĲ���
        {
            -- ��������Ŀ����ļ��е�dll��ָ���ļ�����
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
    -- ���Թ��˶��ѡ�һ������
    -- filter {"system:windows", "configurations:Release"}
    --     buildoptions "/MT"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
    
    files   -- ���������ļ�
    {
        "%{prj.name}/src/**.h",    
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "Hazel/vendor/spdlog/include",
        "Hazel/src"
    }

    links        --���ӿ�
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
