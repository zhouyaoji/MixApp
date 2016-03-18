{
    'targets': [
      {
        'target_name': '<cpp_file_name>',
        'type': 'executable',
        'dependencies': [
        ],
        'defines': [
        ],
        'linkflags': [
        ],
        'conditions': [
          ['OS=="linux"', {
            'sources': [
              '<cpp_file_name>.cpp',
            ],
            'ldflags': [
              '-lcurl'
            ],
            'defines': [
            ],
            'cflags': [
               '-g -fPIC',
               '-pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector ',
               '--param=ssp-buffer-size=4 -m64 -mtune=generic -fno-strict-aliasing',
            ],
            'libraries': [
              '/opt/appdynamics-sdk-native/sdk_lib/lib/libappdynamics_native_sdk.so',
            ],

            'include_dirs': [
              '/opt/appdynamics-sdk-native/sdk_lib',
            ],
          }],
          ['OS=="win"', {
          'default_configuration': 'Debug',
          'configurations':
          {
            'Debug': {
            'defines': [ 'DEBUG', '_DEBUG' ],
            'msvs_settings': {
                'VCCLCompilerTool': {
                  'RuntimeLibrary': 3,
                },
                'VCLinkerTool': {
                  'LinkTimeCodeGeneration': 1,
                  'OptimizeReferences': 2,
                  'EnableCOMDATFolding': 2,
                  'LinkIncremental': 1,
                  'GenerateDebugInformation': 'true'
                }
              }
            },
          },
          'sources': [
              'sdk_sanity_win.cpp',
            ],
            'defines': [
            ],
            'include_dirs': [
              'c:/temp/appdynamics_sdk_native/sdk_lib/include'
            ],
            'libraries': [
              'C:/temp/appdynamics_sdk_native/sdk_lib/lib/appdynamics_native_sdk.lib',
            ],
          }],
        ],
    }]
  }
