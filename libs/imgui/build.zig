const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const cflags = &.{"-fno-sanitize=undefined"};

    const lib = b.addStaticLibrary(.{
        .name = "imgui",
        .target = target,
        .optimize = optimize,
    });

    lib.addIncludePath(b.path(""));
    lib.installHeadersDirectory(b.path(""), ".", .{});
    lib.installHeadersDirectory(b.path("backends/"), ".", .{});

    lib.linkLibC();
    lib.linkLibCpp();

    const glfw = b.dependency("glfw", .{});
    lib.addIncludePath(glfw.path("include"));

    lib.addCSourceFiles(.{
        .files = &sources,
        .flags = cflags,
    });

    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "imgui.cpp",
    "imgui_widgets.cpp",
    "imgui_tables.cpp",
    "imgui_draw.cpp",
    "imgui_demo.cpp",
    "implot_demo.cpp",
    "implot.cpp",
    "implot_items.cpp",
    "backends/imgui_impl_glfw.cpp",
    "backends/imgui_impl_opengl3.cpp",
};
