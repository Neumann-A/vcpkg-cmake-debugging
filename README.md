# vcpkg-cmake-debugging
Example for how to debug vcpkg portfiles with the VS CMake extension (currently only windows)

### How does it work?
'cmake.cmakePath' is set to 'vcpkg-debug.bat' as long as no debugger is getting attached cmake is called normally. As soon as a debugger is attached vcpkg-debug.bat calls vcpkg with the correct '--x-cmake-args' to pass on the debugger info to cmake in vcpkg. The rest ist magic ;). Port being configured inside vcpkg cannot currently be debuged due to limitations of the debugger extension waiting for 'Waiting for debugger client to connect...' in stdout which never gets triggered since vcpkg/cmake writes the configure output to a file instead. https://github.com/microsoft/vscode-cmake-tools/issues/3248 needs to be resolved.

### What is required?
- VSCode with CMake-Tools extension version 1.15 (preview mode)
- CMake 3.27.0
- vcpkg with cmake 3.27.0 internally used (deleted the CMake folders from downloads; vcpkg tends to use its own cmake version if it is available)
- Adjust the variables, explicitly vcpkg_exe, in the batch script to your case (Yeah I could run cmake in FetchContent mode to pull vcpkg for you but ..... no ;) )

### Troubleshooting
If the debugger hangs idefinetly you probably did something wrong. My best guess here is that vcpkg did not use cmake 3.27