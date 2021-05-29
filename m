Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EBC394BB3
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 12:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhE2Kdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 06:33:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhE2Kds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 29 May 2021 06:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622284331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5E4l/esOVYg449LMKlePuHCv92fIFaDLiFfx2hrPk04=;
        b=M06AB+Lnbiy2jJ6mUPHsNRzUgv+lZ0U0/hz6iGaTEIS+4JntR+S6y2WzR5v52MkyG+iQ9V
        x4ZuJxK7yZfIdHDgCx+2hvg4soWl7o/wrXOVcH/BFGJYCkQ4bSJsuaNO9Ly5ryfnKHJ8Ow
        1EHcNGxhVDi26miiN93ZeVIdLS8Jak0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-sj8l9PZ7PnuxQZZz1V1VjA-1; Sat, 29 May 2021 06:32:07 -0400
X-MC-Unique: sj8l9PZ7PnuxQZZz1V1VjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA54101371C;
        Sat, 29 May 2021 10:32:06 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AB9E100164A;
        Sat, 29 May 2021 10:32:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes and new selftests for Linux 5.14-rc4
Date:   Sat, 29 May 2021 06:32:06 -0400
Message-Id: <20210529103206.3853545-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 000ac42953395a4f0a63d5db640c5e4c88a548c5:

  selftests: kvm: fix overlapping addresses in memslot_perf_test (2021-05-29 06:28:06 -0400)

----------------------------------------------------------------
ARM fixes:
* Another state update on exit to userspace fix

* Prevent the creation of mixed 32/64 VMs

* Fix regression with irqbypass not restarting the guest on failed connect

* Fix regression with debug register decoding resulting in overlapping access

* Commit exception state on exit to usrspace

* Fix the MMU notifier return values

* Add missing 'static' qualifiers in the new host stage-2 code

x86 fixes:
* fix guest missed wakeup with assigned devices

* fix WARN reported by syzkaller

* do not use BIT() in UAPI headers

* make the kvm_amd.avic parameter bool

PPC fixes:
* make halt polling heuristics consistent with other architectures

selftests:
* various fixes

* new performance selftest memslot_perf_test

* test UFFD minor faults in demand_paging_test

----------------------------------------------------------------
Axel Rasmussen (9):
      KVM: selftests: trivial comment/logging fixes
      KVM: selftests: simplify setup_demand_paging error handling
      KVM: selftests: compute correct demand paging size
      KVM: selftests: allow different backing source types
      KVM: selftests: refactor vm_mem_backing_src_type flags
      KVM: selftests: add shmem backing source type
      KVM: selftests: create alias mappings when using shared memory
      KVM: selftests: allow using UFFD minor faults for demand paging
      KVM: selftests: add shared hugetlbfs backing source type

David Matlack (5):
      KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
      KVM: selftests: Ignore CPUID.0DH.1H in get_cpuid_test
      KVM: selftests: Fix hang in hardware_disable_test
      KVM: selftests: Print a message if /dev/kvm is missing
      KVM: x86/mmu: Fix comment mentioning skip_4k

Joe Richey (1):
      KVM: X86: Use _BITUL() macro in UAPI headers

Maciej S. Szmigiero (2):
      KVM: selftests: Keep track of memslots more efficiently
      KVM: selftests: add a memslot-related performance benchmark

Marc Zyngier (4):
      KVM: arm64: Move __adjust_pc out of line
      KVM: arm64: Commit pending PC adjustemnts before returning to userspace
      KVM: arm64: Fix debug register indexing
      KVM: arm64: Prevent mixed-width VM creation

Marcelo Tosatti (3):
      KVM: x86: add start_assignment hook to kvm_x86_ops
      KVM: rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK
      KVM: VMX: update vcpu posted-interrupt descriptor when assigning device

Paolo Bonzini (6):
      Merge tag 'kvmarm-fixes-5.13-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: SVM: make the avic parameter a bool
      selftests: kvm: fix potential issue with ELF loading
      selftests: kvm: do only 1 memslot_perf_test run by default
      Merge tag 'kvmarm-fixes-5.13-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      selftests: kvm: fix overlapping addresses in memslot_perf_test

Quentin Perret (2):
      KVM: arm64: Mark pkvm_pgtable_mm_ops static
      KVM: arm64: Mark the host stage-2 memory pools static

Vitaly Kuznetsov (2):
      KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC check
      KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC check

Wanpeng Li (7):
      KVM: PPC: exit halt polling on need_resched()
      KVM: X86: Bail out of direct yield in case of under-committed scenarios
      KVM: X86: Fix vCPU preempted state from guest's point of view
      KVM: X86: hyper-v: Task srcu lock when accessing kvm_memslots()
      KVM: LAPIC: Narrow the timer latency between wait_lapic_expire and world switch
      KVM: X86: Fix warning caused by stale emulation context
      KVM: X86: Kill off ctxt->ud

Yuan Yao (1):
      KVM: X86: Use kvm_get_linear_rip() in single-step and #DB/#BP interception

Zenghui Yu (1):
      KVM: arm64: Resolve all pending PC updates before immediate exit

Zhenzhong Duan (1):
      selftests: kvm: make allocation of extra memory take effect

Zhu Lingshan (1):
      Revert "irqbypass: do not start cons/prod when failed connect"

kernel test robot (1):
      KVM: arm64: Fix boolreturn.cocci warnings

 Documentation/virt/kvm/api.rst                     |    4 +-
 Documentation/virt/kvm/vcpu-requests.rst           |    8 +-
 arch/arm64/include/asm/kvm_asm.h                   |    3 +
 arch/arm64/include/asm/kvm_emulate.h               |    5 +
 arch/arm64/kvm/arm.c                               |   20 +-
 arch/arm64/kvm/hyp/exception.c                     |   18 +-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h         |   18 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |    8 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |    4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |    2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |    3 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |    3 +-
 arch/arm64/kvm/mmu.c                               |   12 +-
 arch/arm64/kvm/reset.c                             |   28 +-
 arch/arm64/kvm/sys_regs.c                          |   42 +-
 arch/powerpc/include/asm/kvm_host.h                |    1 +
 arch/powerpc/kvm/book3s_hv.c                       |    2 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    1 +
 arch/x86/include/asm/kvm_host.h                    |   16 +-
 arch/x86/include/asm/kvm_para.h                    |   10 +-
 arch/x86/include/uapi/asm/kvm.h                    |    2 +
 arch/x86/kernel/kvm.c                              |  129 ++-
 arch/x86/kernel/kvmclock.c                         |   26 +-
 arch/x86/kvm/cpuid.c                               |   20 +-
 arch/x86/kvm/emulate.c                             |    7 +-
 arch/x86/kvm/hyperv.c                              |    8 +
 arch/x86/kvm/kvm_emulate.h                         |    4 +-
 arch/x86/kvm/lapic.c                               |   18 +-
 arch/x86/kvm/mmu/mmu.c                             |   20 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   23 +-
 arch/x86/kvm/svm/avic.c                            |    6 +-
 arch/x86/kvm/svm/nested.c                          |   23 +-
 arch/x86/kvm/svm/sev.c                             |   32 +-
 arch/x86/kvm/svm/svm.c                             |   66 +-
 arch/x86/kvm/svm/svm.h                             |    3 +-
 arch/x86/kvm/vmx/capabilities.h                    |    6 +-
 arch/x86/kvm/vmx/nested.c                          |   29 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   14 +
 arch/x86/kvm/vmx/posted_intr.h                     |    1 +
 arch/x86/kvm/vmx/vmx.c                             |  226 ++---
 arch/x86/kvm/vmx/vmx.h                             |   12 +-
 arch/x86/kvm/x86.c                                 |  180 +++-
 include/linux/kvm_host.h                           |    8 +-
 include/uapi/linux/kvm.h                           |    5 +-
 tools/include/uapi/linux/kvm.h                     |    5 +-
 tools/kvm/kvm_stat/kvm_stat.txt                    |    2 +-
 tools/testing/selftests/kvm/.gitignore             |    1 +
 tools/testing/selftests/kvm/Makefile               |    3 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |  174 ++--
 .../testing/selftests/kvm/hardware_disable_test.c  |   32 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |    4 +-
 tools/testing/selftests/kvm/include/test_util.h    |   12 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  278 ++++--
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   17 +-
 tools/testing/selftests/kvm/lib/perf_test_util.c   |    4 +-
 tools/testing/selftests/kvm/lib/rbtree.c           |    1 +
 tools/testing/selftests/kvm/lib/test_util.c        |   51 +-
 tools/testing/selftests/kvm/lib/x86_64/handlers.S  |    4 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   16 +-
 .../kvm/memslot_modification_stress_test.c         |   18 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    | 1037 ++++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |   88 +-
 .../testing/selftests/kvm/x86_64/get_cpuid_test.c  |    5 +
 .../selftests/kvm/x86_64/get_msr_index_features.c  |    8 +-
 virt/kvm/kvm_main.c                                |    9 +-
 virt/lib/irqbypass.c                               |   16 +-
 66 files changed, 2234 insertions(+), 627 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/rbtree.c
 create mode 100644 tools/testing/selftests/kvm/memslot_perf_test.c

