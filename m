Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FA81F7BA0
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 18:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgFLQbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 12:31:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29207 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726258AbgFLQbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 12:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591979478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h+wFNh6g1LwXDIcDojVcNUqQDtORiQxjs31ZgD6xXJA=;
        b=XyVIc4LdB30f1hrwp7TGmhldyHbb5nkpCe5gqWWwBGu7T9fk69Dq59+symM9JOQ+EPyJED
        KT0LZnNdRARoOCf2ha8pZ53A76cggLmakcIhA+mXIayLTwPZxh49kppWKskO0wwFo93j/D
        EHyl/3Nbtgx/b3rEkeNviu2B2PSD1N4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-outWB-s5OVqPgnDOmzv44A-1; Fri, 12 Jun 2020 12:31:14 -0400
X-MC-Unique: outWB-s5OVqPgnDOmzv44A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0A14800053;
        Fri, 12 Jun 2020 16:31:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D9D210013C1;
        Fri, 12 Jun 2020 16:31:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM patches for Linux 5.8
Date:   Fri, 12 Jun 2020 12:31:12 -0400
Message-Id: <20200612163112.16001-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6929f71e46bdddbf1c4d67c2728648176c67c555:

  atomisp: avoid warning about unused function (2020-06-03 21:22:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 49b3deaad3452217d62dbd78da8df24eb0c7e169:

  Merge tag 'kvmarm-fixes-5.8-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2020-06-11 14:02:32 -0400)

----------------------------------------------------------------
MIPS:
- Loongson port

PPC:
- Fixes

ARM:
- Fixes

x86:
- KVM_SET_USER_MEMORY_REGION optimizations
- Fixes
- Selftest fixes

The guest side of the asynchronous page fault work has been delayed to 5.9
in order to sync with Thomas's interrupt entry rework.

----------------------------------------------------------------
Anthony Yznaga (3):
      KVM: x86: remove unnecessary rmap walk of read-only memslots
      KVM: x86: avoid unnecessary rmap walks when creating/moving slots
      KVM: x86: minor code refactor and comments fixup around dirty logging

Babu Moger (1):
      KVM: x86: Move MPK feature detection to common code

Chen Zhou (1):
      KVM: PPC: Book3S HV: Remove redundant NULL check

Colin Ian King (1):
      kvm: i8254: remove redundant assignment to pointer s

Denis Efremov (1):
      KVM: Use vmemdup_user()

Eiichi Tsukata (1):
      KVM: x86: Fix APIC page invalidation race

Felipe Franciosi (1):
      KVM: x86: respect singlestep when emulating instruction

Huacai Chen (12):
      KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
      KVM: MIPS: Add EVENTFD support which is needed by VHOST
      KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
      KVM: MIPS: Introduce and use cpu_guest_has_ldpte
      KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
      KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
      KVM: MIPS: Add more types of virtual interrupts
      KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
      KVM: MIPS: Add CPUCFG emulation for Loongson-3
      KVM: MIPS: Add CONFIG6 and DIAG registers emulation
      KVM: MIPS: Add more MMIO load/store instructions emulation
      KVM: MIPS: Enable KVM support for Loongson-3

James Morse (3):
      KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
      KVM: arm64: Add emulation for 32bit guests accessing ACTLR2
      KVM: arm64: Stop save/restoring ACTLR_EL1

Laurent Dufour (2):
      KVM: PPC: Book3S HV: Read ibm,secure-memory nodes
      KVM: PPC: Book3S HV: Relax check on H_SVM_INIT_ABORT

Marc Zyngier (9):
      KVM: arm64: Flush the instruction cache if not unmapping the VM on reboot
      KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
      KVM: arm64: Handle PtrAuth traps early
      KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
      KVM: arm64: Remove host_cpu_context member from vcpu structure
      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
      KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
      KVM: arm64: Move hyp_symbol_addr() to kvm_asm.h
      Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next

Paolo Bonzini (7):
      KVM: let kvm_destroy_vm_debugfs clean up vCPU debugfs directories
      Merge tag 'kvm-ppc-next-5.8-1' of git://git.kernel.org/.../paulus/powerpc into HEAD
      KVM: x86: emulate reserved nops from 0f/18 to 0f/1f
      KVM: SVM: fix calls to is_intercept
      Merge branch 'kvm-basic-exit-reason' into HEAD
      KVM: x86: do not pass poisoned hva to __kvm_set_memory_region
      Merge tag 'kvmarm-fixes-5.8-1' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Remove user-triggerable WARN_ON
      KVM: PPC: Book3S HV: Close race with page faults around memslot flushes

Qian Cai (2):
      KVM: PPC: Book3S HV: Ignore kmemleak false positives
      KVM: PPC: Book3S: Fix some RCU-list locks

Sean Christopherson (5):
      KVM: VMX: Always treat MSR_IA32_PERF_CAPABILITIES as a valid PMU MSR
      x86/kvm: Remove defunct KVM_DEBUG_FS Kconfig
      KVM: selftests: Ignore KVM 5-level paging support for VM_MODE_PXXV48_4K
      KVM: x86: Unexport x86_fpu_cache and make it static
      KVM: nVMX: Consult only the "basic" exit reason when routing nested exit

Tianjia Zhang (2):
      KVM: PPC: Remove redundant kvm_run from vcpu_arch
      KVM: PPC: Clean up redundant 'kvm_run' parameters

Vitaly Kuznetsov (10):
      KVM: selftests: Fix build with "make ARCH=x86_64"
      KVM: VMX: Properly handle kvm_read/write_guest_virt*() result
      Revert "KVM: x86: work around leak of uninitialized stack contents"
      KVM: selftests: Add x86_64/debug_regs to .gitignore
      KVM: selftests: fix vmx_preemption_timer_test build with GCC10
      KVM: selftests: do not substitute SVM/VMX check with KVM_CAP_NESTED_STATE check
      KVM: selftests: Don't probe KVM_CAP_HYPERV_ENLIGHTENED_VMCS when nested VMX is unsupported
      KVM: async_pf: Cleanup kvm_setup_async_pf()
      KVM: async_pf: Inject 'page ready' event only if 'page not present' was previously injected
      KVM: selftests: fix sync_with_host() in smm_test

Xiaoyao Li (1):
      KVM: x86: Assign correct value to array.maxnent

Xing Li (2):
      KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
      KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits

 arch/arm64/include/asm/kvm_asm.h                   |  33 +-
 arch/arm64/include/asm/kvm_emulate.h               |   6 -
 arch/arm64/include/asm/kvm_host.h                  |   9 +-
 arch/arm64/include/asm/kvm_mmu.h                   |  20 -
 arch/arm64/kvm/aarch32.c                           |  28 ++
 arch/arm64/kvm/arm.c                               |  25 +-
 arch/arm64/kvm/handle_exit.c                       |  32 +-
 arch/arm64/kvm/hyp/debug-sr.c                      |   4 +-
 arch/arm64/kvm/hyp/switch.c                        |  65 ++-
 arch/arm64/kvm/hyp/sysreg-sr.c                     |   8 +-
 arch/arm64/kvm/pmu.c                               |   8 +-
 arch/arm64/kvm/sys_regs.c                          |  25 +-
 arch/arm64/kvm/sys_regs_generic_v8.c               |  10 +
 arch/mips/Kconfig                                  |   1 +
 arch/mips/include/asm/cpu-features.h               |   3 +
 arch/mips/include/asm/kvm_host.h                   |  52 ++-
 arch/mips/include/asm/mipsregs.h                   |   4 +
 arch/mips/include/uapi/asm/inst.h                  |  11 +
 arch/mips/kernel/cpu-probe.c                       |   5 +-
 arch/mips/kvm/Kconfig                              |   1 +
 arch/mips/kvm/Makefile                             |   5 +-
 arch/mips/kvm/emulate.c                            | 503 ++++++++++++++++++++-
 arch/mips/kvm/entry.c                              |  19 +-
 arch/mips/kvm/interrupt.c                          |  93 +---
 arch/mips/kvm/interrupt.h                          |  14 +-
 arch/mips/kvm/loongson_ipi.c                       | 214 +++++++++
 arch/mips/kvm/mips.c                               |  47 +-
 arch/mips/kvm/tlb.c                                |  41 ++
 arch/mips/kvm/trap_emul.c                          |   3 +
 arch/mips/kvm/vz.c                                 | 237 +++++++---
 arch/powerpc/include/asm/kvm_book3s.h              |  16 +-
 arch/powerpc/include/asm/kvm_host.h                |   1 -
 arch/powerpc/include/asm/kvm_ppc.h                 |  27 +-
 arch/powerpc/kvm/book3s.c                          |   4 +-
 arch/powerpc/kvm/book3s.h                          |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |  12 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |  36 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |  18 +-
 arch/powerpc/kvm/book3s_emulate.c                  |  10 +-
 arch/powerpc/kvm/book3s_hv.c                       |  75 +--
 arch/powerpc/kvm/book3s_hv_nested.c                |  15 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |  14 +
 arch/powerpc/kvm/book3s_paired_singles.c           |  72 +--
 arch/powerpc/kvm/book3s_pr.c                       |  30 +-
 arch/powerpc/kvm/booke.c                           |  36 +-
 arch/powerpc/kvm/booke.h                           |   8 +-
 arch/powerpc/kvm/booke_emulate.c                   |   2 +-
 arch/powerpc/kvm/e500_emulate.c                    |  15 +-
 arch/powerpc/kvm/emulate.c                         |  10 +-
 arch/powerpc/kvm/emulate_loadstore.c               |  32 +-
 arch/powerpc/kvm/powerpc.c                         |  72 +--
 arch/powerpc/kvm/trace_hv.h                        |   6 +-
 arch/s390/include/asm/kvm_host.h                   |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/x86/Kconfig                                   |   8 -
 arch/x86/include/asm/kvm_host.h                    |   3 +-
 arch/x86/kernel/kvm.c                              |   1 -
 arch/x86/kvm/cpuid.c                               |  31 +-
 arch/x86/kvm/debugfs.c                             |  10 +-
 arch/x86/kvm/emulate.c                             |   8 +-
 arch/x86/kvm/i8254.c                               |   1 -
 arch/x86/kvm/svm/nested.c                          |   2 +-
 arch/x86/kvm/svm/svm.c                             |   4 +-
 arch/x86/kvm/vmx/nested.c                          |  82 ++--
 arch/x86/kvm/vmx/pmu_intel.c                       |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  38 +-
 arch/x86/kvm/vmx/vmx.h                             |   2 +
 arch/x86/kvm/x86.c                                 | 139 +++---
 include/linux/kvm_host.h                           |   8 +-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   4 +
 .../selftests/kvm/include/x86_64/svm_util.h        |   1 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |   5 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  11 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |  10 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |   9 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |   5 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |   3 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c      |  17 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |  13 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c         |   4 +
 virt/kvm/async_pf.c                                |  21 +-
 virt/kvm/kvm_main.c                                |  53 ++-
 83 files changed, 1801 insertions(+), 740 deletions(-)
 create mode 100644 arch/mips/kvm/loongson_ipi.c

