project "Glad"
	kind "StaticLib"
	language "C"
	staticruntime "On"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files{
		"include/glad/glad.h",
		"include/KHR/khrplatform.h",
		"src/glad.C",
	}
	includedirs{
		"include" -- 为了glad.c直接#include <glad/glad.h>，而不用#include <include/glad/glad.h>
	}

    filter "system:windows"
        systemversion "10.0.17763.0"

	filter "configurations:Debug"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		runtime "Release"
		optimize "On"