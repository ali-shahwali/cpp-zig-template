const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "glfw",
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibC();

    lib.installHeadersDirectory(b.path("include/GLFW/"), "GLFW", .{});

    lib.addIncludePath(b.path("include/"));
    lib.defineCMacro("WL_MARSHAL_FLAG_DESTROY", "1");

    switch (target.result.os.tag) {
        .windows => {
            lib.linkSystemLibrary("gdi32");
            lib.linkSystemLibrary("user32");
            lib.linkSystemLibrary("shell32");
            lib.linkSystemLibrary("opengl32");

            const flags = [_][]const u8{
                "-D_GLFW_WIN32",
                "-Isrc",
            };

            lib.addCSourceFiles(.{
                .files = &base_sources,
                .flags = &flags,
            });

            lib.addCSourceFiles(.{
                .files = &win32_sources,
                .flags = &flags,
            });
        },
        else => {
            const dep = b.dependency("wayland_headers", .{
                .target = target,
                .optimize = optimize,
            });
            lib.linkLibrary(dep.artifact("wayland-headers"));
            lib.installLibraryHeaders(dep.artifact("wayland-headers"));

            const flags = [_][]const u8{
                "-D_GLFW_WAYLAND",
                "-Isrc",
                "-Wno-implicit-function-declaration",
            };

            lib.addCSourceFiles(.{
                .files = &base_sources,
                .flags = &flags,
            });
            lib.addCSourceFiles(.{
                .files = &linux_wl_sources,
                .flags = &flags,
            });
            lib.addCSourceFiles(.{
                .files = &linux_sources,
                .flags = &flags,
            });
        },
    }

    b.installArtifact(lib);
}

const base_sources = [_][]const u8{
    "src/context.c",
    "src/egl_context.c",
    "src/init.c",
    "src/input.c",
    "src/monitor.c",
    "src/null_init.c",
    "src/null_joystick.c",
    "src/null_monitor.c",
    "src/null_window.c",
    "src/osmesa_context.c",
    "src/platform.c",
    "src/vulkan.c",
    "src/window.c",
};

const linux_sources = [_][]const u8{
    "src/linux_joystick.c",
    "src/posix_module.c",
    "src/posix_poll.c",
    "src/posix_thread.c",
    "src/posix_time.c",
    "src/xkb_unicode.c",
};

const linux_wl_sources = [_][]const u8{
    "src/wl_init.c",
    "src/wl_monitor.c",
    "src/wl_window.c",
};

const win32_sources = [_][]const u8{
    "src/wgl_context.c",
    "src/win32_init.c",
    "src/win32_joystick.c",
    "src/win32_module.c",
    "src/win32_monitor.c",
    "src/win32_thread.c",
    "src/win32_time.c",
    "src/win32_window.c",
};
