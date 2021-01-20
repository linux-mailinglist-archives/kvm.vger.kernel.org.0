Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C5C2FCED5
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 12:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbhATLJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 06:09:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731491AbhATJhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 04:37:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611135331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z772Qt9JiJWD0EmElx1f24c9GfndbwsLkJfCmUU+Pe0=;
        b=S/jnafcYfqcZssJ2VTqzkGi5RqM8LNMmDVe5UjmCdv/NYHjnRswXBfcZ/k2/XWxVFBdQB+
        /Y+8H6OpSVxomAUrniV84qiMh1ZFzxoCuDO6Y1+h8DEvtX05za96tY8LN8VpZ7sBdUl3pb
        kdGbYSWA8Tq3vGCJMRRq/XdrzT4n+FM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-EPgEeZn6OJ-74YRC-5IiBw-1; Wed, 20 Jan 2021 04:35:29 -0500
X-MC-Unique: EPgEeZn6OJ-74YRC-5IiBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68E08E743
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 09:35:28 +0000 (UTC)
Received: from thuth.com (ovpn-114-135.ams2.redhat.com [10.36.114.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 821285D755;
        Wed, 20 Jan 2021 09:35:27 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH] travis.yml: Remove the CI file for Travis, it's of no use anymore
Date:   Wed, 20 Jan 2021 10:35:25 +0100
Message-Id: <20210120093525.463974-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With its new policy, Travis-CI has become completely useless for
OSS projects like kvm-unit-tests. Thus remove the YML file now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 180 ----------------------------------------------------
 1 file changed, 180 deletions(-)
 delete mode 100644 .travis.yml

diff --git a/.travis.yml b/.travis.yml
deleted file mode 100644
index 5af7344..0000000
--- a/.travis.yml
+++ /dev/null
@@ -1,180 +0,0 @@
-dist: focal
-language: c
-cache: ccache
-git:
-  submodules: false
-
-jobs:
-  include:
-
-    - addons:
-        apt_packages: gcc qemu-system-x86
-      env:
-      - CONFIG=""
-      - BUILD_DIR="."
-      - TESTS="access asyncpf debug emulator ept hypercall hyperv_clock
-          hyperv_connections hyperv_stimer hyperv_synic idt_test intel_iommu
-          ioapic ioapic-split kvmclock_test memory msr pcid pcid-disabled
-          rdpru realmode rmap_chain s3 setjmp sieve smap smptest smptest3
-          syscall tsc tsc_adjust tsx-ctrl umip vmexit_cpuid vmexit_inl_pmtimer
-          vmexit_ipi vmexit_ipi_halt vmexit_mov_from_cr8 vmexit_mov_to_cr8
-          vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-          vmexit_vmcall vmx_apic_passthrough_thread xsave"
-      - ACCEL="kvm"
-
-    - addons:
-        apt_packages: clang-10 qemu-system-x86
-      compiler: clang
-      env:
-      - CONFIG="--cc=clang-10"
-      - BUILD_DIR="x86-builddir"
-      - TESTS="access asyncpf debug emulator ept hypercall hyperv_clock
-          hyperv_connections hyperv_stimer hyperv_synic idt_test intel_iommu
-          ioapic ioapic-split kvmclock_test memory msr pcid pcid-disabled
-          rdpru realmode rmap_chain s3 setjmp sieve smap smptest smptest3
-          syscall tsc tsc_adjust tsx-ctrl umip vmexit_cpuid vmexit_inl_pmtimer
-          vmexit_ipi vmexit_ipi_halt vmexit_mov_from_cr8 vmexit_mov_to_cr8
-          vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-          vmexit_vmcall vmx_apic_passthrough_thread xsave"
-      - ACCEL="kvm"
-
-    - addons:
-        apt_packages: gcc gcc-multilib qemu-system-x86
-      env:
-      - CONFIG="--arch=i386"
-      - BUILD_DIR="."
-      - TESTS="asyncpf kvmclock_test msr pmu realmode s3 setjmp sieve smap
-          smptest smptest3 taskswitch taskswitch2 tsc tsc_adjust tsx-ctrl umip"
-      - ACCEL="kvm"
-
-    - addons:
-        apt_packages: gcc gcc-multilib qemu-system-x86
-      env:
-      - CONFIG="--arch=i386"
-      - BUILD_DIR="i386-builddir"
-      - TESTS="cmpxchg8b vmexit_vmcall vmexit_cpuid vmexit_ipi vmexit_ipi_halt
-          vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
-          vmexit_inl_pmtimer vmexit_tscdeadline vmexit_tscdeadline_immed"
-      - ACCEL="kvm"
-
-    - addons:
-        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
-      env:
-      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
-      - BUILD_DIR="."
-      - TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
-
-    - addons:
-        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
-      env:
-      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
-      - BUILD_DIR="arm-buildir"
-      - TESTS="pci-test pmu gicv2-active gicv3-active psci selftest-setup"
-
-    - addons:
-        apt_packages: gcc-aarch64-linux-gnu qemu-system-aarch64
-      env:
-      - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
-      - BUILD_DIR="."
-      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi pci-test
-          pmu-cycle-counter pmu-event-counter-config pmu-sw-incr psci
-          selftest-setup selftest-smp selftest-vectors-kernel
-          selftest-vectors-user timer"
-
-    - arch: arm64
-      addons:
-        apt_packages: clang-10 qemu-system-aarch64
-      compiler: clang
-      env:
-      - CONFIG="--arch=arm64 --cc=clang-10"
-      - BUILD_DIR="arm64-buildir"
-      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi pci-test
-          pmu-cycle-counter pmu-event-counter-config pmu-sw-incr selftest-setup
-          selftest-smp selftest-vectors-kernel selftest-vectors-user timer"
-
-    - addons:
-        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
-      env:
-      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
-      - BUILD_DIR="."
-      - TESTS="selftest-setup spapr_hcall emulator rtas-set-time-of-day"
-      - ACCEL="tcg,cap-htm=off"
-
-    - addons:
-        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
-      env:
-      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
-      - BUILD_DIR="ppc64le-buildir"
-      - TESTS="rtas-get-time-of-day rtas-get-time-of-day-base"
-      - ACCEL="tcg,cap-htm=off"
-
-    - addons:
-        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
-      env:
-      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
-      - BUILD_DIR="."
-      - TESTS="cpumodel css diag10 diag288 diag308 emulator intercept sclp-1g
-          sclp-3g selftest-setup"
-      - ACCEL="tcg,firmware=s390x/run"
-
-    - addons:
-        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
-      env:
-      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
-      - BUILD_DIR="s390x-builddir"
-      - TESTS="sieve skey stsi vector"
-      - ACCEL="tcg,firmware=s390x/run"
-
-    - os: osx
-      osx_image: xcode11.6
-      addons:
-        homebrew:
-          packages:
-            - bash
-            - coreutils
-            - gnu-getopt
-            - qemu
-            - x86_64-elf-gcc
-      env:
-      - CONFIG="--cross-prefix=x86_64-elf-"
-      - BUILD_DIR="build"
-      - TESTS="ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
-               vmexit_mov_to_cr8 vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
-               vmexit_ple_round_robin vmexit_tscdeadline
-               vmexit_tscdeadline_immed eventinj msr port80 setjmp
-               syscall tsc rmap_chain umip intel_iommu"
-      - ACCEL="tcg"
-      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
-
-    - os: osx
-      osx_image: xcode11.6
-      addons:
-        homebrew:
-          packages:
-            - bash
-            - coreutils
-            - gnu-getopt
-            - qemu
-            - i686-elf-gcc
-      env:
-      - CONFIG="--arch=i386 --cross-prefix=i686-elf-"
-      - BUILD_DIR="build"
-      - TESTS="cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
-               vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
-               vmexit_ple_round_robin vmexit_tscdeadline
-               vmexit_tscdeadline_immed eventinj port80 setjmp tsc
-               taskswitch umip"
-      - ACCEL="tcg"
-      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
-
-before_script:
-  - if [ "$ACCEL" = "kvm" ]; then
-      sudo chgrp kvm /usr/bin/qemu-system-* ;
-      sudo chmod g+s /usr/bin/qemu-system-* ;
-    fi
-  - mkdir -p $BUILD_DIR && cd $BUILD_DIR
-  - $TRAVIS_BUILD_DIR/configure $CONFIG
-script:
-  - make -j3
-  - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
-  - grep -q PASS results.txt && ! grep -q FAIL results.txt
-- 
2.27.0

