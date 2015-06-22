{
	'variables':
	{
		'mobile': 1,
		
		'variables':
		{
			'java_sdk_path%': '<!(echo ${JAVA_SDK:-/usr/lib/jvm/java-6-openjdk-amd64})',
			'android_sdk_path%': '<!(echo ${ANDROID_SDK})',
			'android_ndk_path%': '<!(echo ${ANDROID_NDK})',
			'android_platform%': '<!(echo ${ANDROID_PLATFORM})',
			'android_build_tools%': '<!(echo ${ANDROID_BUILD_TOOLS})',
		},
		
		'javac_path': '<(java_sdk_path)/bin/javac',
		'jar_path': '<(java_sdk_path)/bin/jar',
		
		'aidl_path': '<(android_sdk_path)/build-tools/<(android_build_tools)/aidl',
		
		'aidl_framework_path': '<(android_sdk_path)/platforms/<(android_platform)/framework.aidl',
		
		'java_classpath': '<(android_sdk_path)/platforms/<(android_platform)/android.jar',
		
		'output_dir': '../android-<(target_arch)-bin',
	},
	
	'target_defaults':
	{
		'variables':
		{
			'app_bundle_suffix': '',
			'ext_bundle_suffix': '',
			'lib_suffix': '',
			'ext_suffix': '',
			'exe_suffix': '',
			'debug_info_suffix': '.dbg',
		},
	
		'target_conditions':
		[
			[
				'_toolset == "host"',
				{
					'includes':
					[
						'linux-settings.gypi',
					],
				},
				{
					'includes':
					[
						'android-settings.gypi',
					],
				},
			],
		],
	},
}
