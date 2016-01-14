// RUN: rm -rf %t && mkdir %t
// RUN: touch %t/a.swift %t/b.swift %t/c.swift

// RUN: (cd %t && %swiftc_driver_plain -driver-use-frontend-path %S/Inputs/filelists/check-filelist-abc.py -emit-module ./a.swift ./b.swift ./c.swift -module-name main -driver-use-filelists -output-file-map=%S/Inputs/filelists/output.json 2>&1 | FileCheck %s)

// CHECK-NOT: Handled
// CHECK: Handled a.swift
// CHECK-NEXT: Handled b.swift
// CHECK-NEXT: Handled c.swift
// CHECK-NEXT: Handled modules
// CHECK-NOT: Handled

// RUN: %swiftc_driver_plain -driver-use-frontend-path %S/Inputs/filelists/check-filelist-abc.py -c %t/a.swift %t/b.swift %t/c.swift -module-name main -driver-use-filelists -force-single-frontend-invocation 2>&1 | FileCheck -check-prefix=CHECK-WMO %s

// CHECK-NOT: Handled
// CHECK-WMO: Handled all
// CHECK-NOT: output
// CHECK-NOT: Handled


// RUN: (cd %t && %swiftc_driver_plain -driver-use-frontend-path %S/Inputs/filelists/check-filelist-abc.py -emit-library ./a.swift ./b.swift ./c.swift -module-name main -driver-use-filelists -output-file-map=%S/Inputs/filelists/output.json -force-single-frontend-invocation -num-threads 1 2>&1 | FileCheck -check-prefix=CHECK-WMO-THREADED %s)
// RUN: (cd %t && %swiftc_driver_plain -driver-use-frontend-path %S/Inputs/filelists/check-filelist-abc.py -emit-library ./a.swift ./b.swift ./c.swift -module-name main -driver-use-filelists -output-file-map=%S/Inputs/filelists/output.json -force-single-frontend-invocation -num-threads 1 -embed-bitcode 2>&1 | FileCheck -check-prefix=CHECK-WMO-THREADED %s)
// RUN: mkdir %t/tmp/
// RUN: (cd %t && env TMPDIR="%t/tmp/" %swiftc_driver_plain -driver-use-frontend-path %S/Inputs/filelists/check-filelist-abc.py -c ./a.swift ./b.swift ./c.swift -module-name main -driver-use-filelists -output-file-map=%S/Inputs/filelists/output.json -force-single-frontend-invocation -num-threads 1 -save-temps 2>&1 | FileCheck -check-prefix=CHECK-WMO-THREADED %s)
// RUN: ls %t/tmp/sources-* %t/tmp/outputs-*

// CHECK-NOT: Handled
// CHECK-WMO-THREADED: Handled all
// CHECK-WMO-THREADED-NEXT: ...with output!
// CHECK-NOT: Handled

// RUN: (cd %t && env PATH=%S/Inputs/filelists/:$PATH %swiftc_driver_plain -driver-use-frontend-path %S/Inputs/filelists/check-filelist-abc.py -emit-library ./a.swift ./b.swift ./c.swift -module-name main -driver-use-filelists -output-file-map=%S/Inputs/filelists/output.json 2>&1 | FileCheck -check-prefix=CHECK-LINK %s)
// RUN: (cd %t && env PATH=%S/Inputs/filelists/:$PATH %swiftc_driver_plain -driver-use-frontend-path %S/Inputs/filelists/check-filelist-abc.py -emit-library ./a.swift ./b.swift ./c.swift -module-name main -driver-use-filelists -output-file-map=%S/Inputs/filelists/output.json -force-single-frontend-invocation -num-threads 1 2>&1 | FileCheck -check-prefix=CHECK-LINK %s)

// CHECK-LINK: Handled link

