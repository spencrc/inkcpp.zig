const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const inkcpp_dep = b.dependency("inkcpp", .{});

    mod.addCSourceFiles(.{
        .root = inkcpp_dep.path("inkcpp"),
        .language = .cpp,
        .flags = &[_][]const u8{"--std=c++23"},
        .files = SRC_FILES,
    });

    const include_paths = &[_]std.Build.LazyPath{
        inkcpp_dep.path("inkcpp"),
        inkcpp_dep.path("inkcpp/include"),
        inkcpp_dep.path("inkcpp/collections"),
        inkcpp_dep.path("shared/private"),
        inkcpp_dep.path("shared/public"),
    };
    for (include_paths) |entry| {
        mod.addIncludePath(entry);
    }

    const lib = b.addLibrary(.{
        .name = "inkcpp_zig",
        .root_module = mod,
    });
    for (include_paths) |entry| lib.installHeadersDirectory(
        entry,
        "include",
        .{ .include_extensions = &[_][]const u8{".h"} },
    );
    b.installArtifact(lib);
}

const SRC_FILES = &[_][]const u8{
    "choice.cpp",
    "container_operations.cpp",
    "functional.cpp",
    "functions.cpp",
    "globals_impl.cpp",
    "header.cpp",
    "hungarian_solver.cpp",
    "list_impl.cpp",
    "list_operations.cpp",
    "list_table.cpp",
    "numeric_operations.cpp",
    "output.cpp",
    "runner_impl.cpp",
    "snapshot_impl.cpp",
    "stack.cpp",
    "story_impl.cpp",
    "story_ptr.cpp",
    "string_operations.cpp",
    "string_table.cpp",
    "system.cpp",
    "value.cpp",
    "collections/restorable.cpp",
};
