Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19B02426BA
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgHLI3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 04:29:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24523 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726182AbgHLI3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 04:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597220982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pBHwdE4nrQbav59yrGa0031nQHXeparWUZMzi9PJWAY=;
        b=UDywF1x96DyCPXnjeC9GAZFDS2AuicxVf2wq55OFjgs24NOJl0DXdP867TSNtML/xnq0Qf
        VZqTeuL4M11k/UfwWpYvyJKn/38OaT9ms5pjboYkpIg0LOX29SksHVMxFlZLa8M0ekmxcB
        N33tsVo7AILdnWoHBF86CYQxs1fOgPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-jXmo_KWuNcyv3IhbT3dsEg-1; Wed, 12 Aug 2020 04:29:40 -0400
X-MC-Unique: jXmo_KWuNcyv3IhbT3dsEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7A3A1DE1;
        Wed, 12 Aug 2020 08:29:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4357962672;
        Wed, 12 Aug 2020 08:29:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.9
Date:   Wed, 12 Aug 2020 04:29:38 -0400
Message-Id: <20200812082938.18976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 06a81c1c7db9bd5de0bd38cd5acc44bb22b99150:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2020-08-08 14:16:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e792415c5d3e0eb52527cce228a72e4392f8cae2:

  KVM: MIPS/VZ: Fix build error caused by 'kvm_run' cleanup (2020-08-11 07:19:41 -0400)

----------------------------------------------------------------
PPC:
* Improvements and bugfixes for secure VM support, giving reduced startup
  time and memory hotplug support.
* Locking fixes in nested KVM code
* Increase number of guests supported by HV KVM to 4094
* Preliminary POWER10 support

ARM:
* Split the VHE and nVHE hypervisor code bases, build the EL2 code
  separately, allowing for the VHE code to now be built with instrumentation
* Level-based TLB invalidation support
* Restructure of the vcpu register storage to accomodate the NV code
* Pointer Authentication available for guests on nVHE hosts
* Simplification of the system register table parsing
* MMU cleanups and fixes
* A number of post-32bit cleanups and other fixes

MIPS:
* compilation fixes

x86:
* bugfixes
* support for the SERIALIZE instruction

----------------------------------------------------------------
Alexander Graf (2):
      KVM: arm64: vgic-its: Change default outer cacheability for {PEND, PROP}BASER
      KVM: arm: Add trace name for ARM_NISV

Alexey Kardashevskiy (1):
      KVM: PPC: Protect kvm_vcpu_read_guest with srcu locks

Alistair Popple (1):
      KVM: PPC: Book3SHV: Enable support for ISA v3.1 guests

Andrew Scull (3):
      arm64: kvm: Remove kern_hyp_va from get_vcpu_ptr
      KVM: arm64: Handle calls to prefixed hyp functions
      KVM: arm64: Move hyp-init.S to nVHE

Christoffer Dall (1):
      KVM: arm64: Factor out stage 2 page table data from struct kvm

Cédric Le Goater (1):
      KVM: PPC: Book3S HV: Increase KVMPPC_NR_LPIDS on POWER8 and POWER9

David Brazdil (16):
      KVM: arm64: Fix symbol dependency in __hyp_call_panic_nvhe
      KVM: arm64: Move __smccc_workaround_1_smc to .rodata
      KVM: arm64: Add build rules for separate VHE/nVHE object files
      KVM: arm64: Use build-time defines in has_vhe()
      KVM: arm64: Build hyp-entry.S separately for VHE/nVHE
      KVM: arm64: Duplicate hyp/tlb.c for VHE/nVHE
      KVM: arm64: Split hyp/switch.c to VHE/nVHE
      KVM: arm64: Split hyp/debug-sr.c to VHE/nVHE
      KVM: arm64: Split hyp/sysreg-sr.c to VHE/nVHE
      KVM: arm64: Duplicate hyp/timer-sr.c for VHE/nVHE
      KVM: arm64: Compile remaining hyp/ files for both VHE/nVHE
      KVM: arm64: Remove __hyp_text macro, use build rules instead
      KVM: arm64: Lift instrumentation restrictions on VHE
      KVM: arm64: Make nVHE ASLR conditional on RANDOMIZE_BASE
      KVM: arm64: Substitute RANDOMIZE_BASE for HARDEN_EL2_VECTORS
      KVM: arm64: Ensure that all nVHE hyp code is in .hyp.text

Gavin Shan (1):
      KVM: arm64: Rename HSR to ESR

Huacai Chen (1):
      MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64

James Morse (5):
      KVM: arm64: Drop the target_table[] indirection
      KVM: arm64: Tolerate an empty target_table list
      KVM: arm64: Move ACTLR_EL1 emulation to the sys_reg_descs array
      KVM: arm64: Remove target_table from exit handlers
      KVM: arm64: Remove the target table

Jiaxun Yang (1):
      MIPS: KVM: Convert a fallthrough comment to fallthrough

Jon Doron (1):
      x86/kvm/hyper-v: Synic default SCONTROL MSR needs to be enabled

Laurent Dufour (3):
      KVM: PPC: Book3S HV: Migrate hot plugged memory
      KVM: PPC: Book3S HV: Move kvmppc_svm_page_out up
      KVM: PPC: Book3S HV: Rework secure mem slot dropping

Marc Zyngier (28):
      KVM: arm64: Enable Address Authentication at EL2 if available
      KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
      KVM: arm64: Allow PtrAuth to be enabled from userspace on non-VHE systems
      KVM: arm64: Check HCR_EL2 instead of shadow copy to swap PtrAuth registers
      KVM: arm64: Simplify PtrAuth alternative patching
      KVM: arm64: Allow in-atomic injection of SPIs
      Merge branch 'kvm-arm64/ttl-for-arm64' into HEAD
      KVM: arm64: Use TTL hint in when invalidating stage-2 translations
      KVM: arm64: Introduce accessor for ctxt->sys_reg
      KVM: arm64: hyp: Use ctxt_sys_reg/__vcpu_sys_reg instead of raw sys_regs access
      KVM: arm64: sve: Use __vcpu_sys_reg() instead of raw sys_regs access
      KVM: arm64: pauth: Use ctxt_sys_reg() instead of raw sys_regs access
      KVM: arm64: debug: Drop useless vpcu parameter
      KVM: arm64: Make struct kvm_regs userspace-only
      KVM: arm64: Move ELR_EL1 to the system register array
      KVM: arm64: Move SP_EL1 to the system register array
      KVM: arm64: Disintegrate SPSR array
      KVM: arm64: Move SPSR_EL1 to the system register array
      KVM: arm64: timers: Rename kvm_timer_sync_hwstate to kvm_timer_sync_user
      KVM: arm64: timers: Move timer registers to the sys_regs file
      KVM: arm64: Don't use has_vhe() for CHOOSE_HYP_SYM()
      Merge branch 'kvm-arm64/el2-obj-v4.1' into kvmarm-master/next-WIP
      Merge branch 'kvm-arm64/pre-nv-5.9' into kvmarm-master/next-WIP
      Merge branch 'kvm-arm64/ptrauth-nvhe' into kvmarm-master/next-WIP
      Merge branch 'kvm-arm64/target-table-no-more' into kvmarm-master/next-WIP
      Merge branch 'kvm-arm64/misc-5.9' into kvmarm-master/next-WIP
      Merge branch 'kvm-arm64/el2-obj-v4.1' into kvmarm-master/next
      Merge branch 'kvm-arm64/misc-5.9' into kvmarm-master/next

Paolo Bonzini (3):
      Merge tag 'kvmarm-5.9' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-next-5.6
      x86: Expose SERIALIZE for supported cpuid
      Merge tag 'kvm-ppc-next-5.9-1' of git://git.kernel.org/.../paulus/powerpc into kvm-next-5.6

Peng Hao (1):
      KVM: arm64: Drop long gone function parameter documentation

Ram Pai (4):
      KVM: PPC: Book3S HV: Fix function definition in book3s_hv_uvmem.c
      KVM: PPC: Book3S HV: Disable page merging in H_SVM_INIT_START
      KVM: PPC: Book3S HV: Track the state GFNs associated with secure VMs
      KVM: PPC: Book3S HV: In H_SVM_INIT_DONE, migrate remaining normal-GFNs to secure-GFNs

Sean Christopherson (1):
      KVM: x86: Don't attempt to load PDPTRs when 64-bit mode is enabled

Tianjia Zhang (1):
      KVM: PPC: Clean up redundant kvm_run parameters in assembly

Will Deacon (4):
      KVM: arm64: Rename kvm_vcpu_dabt_isextabt()
      KVM: arm64: Handle data and instruction external aborts the same way
      KVM: arm64: Don't skip cache maintenance for read-only memslots
      KVM: arm64: Move S1PTW S2 fault logic out of io_mem_abort()

Xingxing Su (1):
      KVM: MIPS/VZ: Fix build error caused by 'kvm_run' cleanup

 Documentation/powerpc/ultravisor.rst               |   3 +
 arch/arm64/Kconfig                                 |  20 +-
 arch/arm64/include/asm/kvm_asm.h                   |  75 +-
 arch/arm64/include/asm/kvm_coproc.h                |   8 -
 arch/arm64/include/asm/kvm_emulate.h               |  75 +-
 arch/arm64/include/asm/kvm_host.h                  |  94 ++-
 arch/arm64/include/asm/kvm_hyp.h                   |  15 +-
 arch/arm64/include/asm/kvm_mmu.h                   |  16 +-
 arch/arm64/include/asm/kvm_ptrauth.h               |  34 +-
 arch/arm64/include/asm/mmu.h                       |   7 -
 arch/arm64/include/asm/virt.h                      |  13 +-
 arch/arm64/kernel/asm-offsets.c                    |   3 +-
 arch/arm64/kernel/cpu_errata.c                     |   4 +-
 arch/arm64/kernel/image-vars.h                     |  54 ++
 arch/arm64/kvm/Kconfig                             |   2 +-
 arch/arm64/kvm/Makefile                            |   4 +-
 arch/arm64/kvm/arch_timer.c                        | 157 +++-
 arch/arm64/kvm/arm.c                               |  57 +-
 arch/arm64/kvm/fpsimd.c                            |   6 +-
 arch/arm64/kvm/guest.c                             |  79 +-
 arch/arm64/kvm/handle_exit.c                       |  32 +-
 arch/arm64/kvm/hyp/Makefile                        |  24 +-
 arch/arm64/kvm/hyp/aarch32.c                       |   8 +-
 arch/arm64/kvm/hyp/entry.S                         |   4 +-
 arch/arm64/kvm/hyp/fpsimd.S                        |   1 -
 arch/arm64/kvm/hyp/hyp-entry.S                     |  21 +-
 .../kvm/hyp/{debug-sr.c => include/hyp/debug-sr.h} |  88 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 511 +++++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         | 193 +++++
 arch/arm64/kvm/hyp/nvhe/Makefile                   |  62 ++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |  77 ++
 arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S           |   5 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   | 272 ++++++
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c                |  46 +
 arch/arm64/kvm/hyp/{ => nvhe}/timer-sr.c           |   6 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      | 154 ++++
 arch/arm64/kvm/hyp/smccc_wa.S                      |  32 +
 arch/arm64/kvm/hyp/switch.c                        | 936 ---------------------
 arch/arm64/kvm/hyp/sysreg-sr.c                     | 333 --------
 arch/arm64/kvm/hyp/tlb.c                           | 242 ------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    | 134 ++-
 arch/arm64/kvm/hyp/vhe/Makefile                    |  11 +
 arch/arm64/kvm/hyp/vhe/debug-sr.c                  |  26 +
 arch/arm64/kvm/hyp/vhe/switch.c                    | 219 +++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 | 114 +++
 arch/arm64/kvm/hyp/vhe/timer-sr.c                  |  12 +
 arch/arm64/kvm/hyp/vhe/tlb.c                       | 162 ++++
 arch/arm64/kvm/inject_fault.c                      |   2 +-
 arch/arm64/kvm/mmio.c                              |   6 -
 arch/arm64/kvm/mmu.c                               | 311 ++++---
 arch/arm64/kvm/regmap.c                            |  37 +-
 arch/arm64/kvm/reset.c                             |  23 +-
 arch/arm64/kvm/sys_regs.c                          | 207 ++---
 arch/arm64/kvm/sys_regs_generic_v8.c               |  96 ---
 arch/arm64/kvm/trace_arm.h                         |   8 +-
 arch/arm64/kvm/va_layout.c                         |   2 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c                   |  24 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   3 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   2 +-
 arch/mips/kvm/emulate.c                            |   2 +-
 arch/mips/kvm/vz.c                                 |   5 +-
 arch/powerpc/include/asm/kvm_book3s_uvmem.h        |  14 +
 arch/powerpc/include/asm/kvm_ppc.h                 |   2 +-
 arch/powerpc/include/asm/reg.h                     |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   8 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   4 +
 arch/powerpc/kvm/book3s_hv.c                       |  26 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |  30 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 | 700 +++++++++++----
 arch/powerpc/kvm/book3s_interrupts.S               |  56 +-
 arch/powerpc/kvm/book3s_pr.c                       |   9 +-
 arch/powerpc/kvm/book3s_rtas.c                     |   2 +
 arch/powerpc/kvm/booke.c                           |   9 +-
 arch/powerpc/kvm/booke_interrupts.S                |   9 +-
 arch/powerpc/kvm/bookehv_interrupts.S              |  10 +-
 arch/powerpc/kvm/powerpc.c                         |   5 +-
 arch/x86/kvm/cpuid.c                               |   3 +-
 arch/x86/kvm/hyperv.c                              |   1 +
 arch/x86/kvm/x86.c                                 |  24 +-
 include/kvm/arm_arch_timer.h                       |  13 +-
 include/trace/events/kvm.h                         |   2 +-
 scripts/kallsyms.c                                 |   1 +
 83 files changed, 3479 insertions(+), 2636 deletions(-)
 rename arch/arm64/kvm/hyp/{debug-sr.c => include/hyp/debug-sr.h} (66%)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/switch.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile
 create mode 100644 arch/arm64/kvm/hyp/nvhe/debug-sr.c
 rename arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S (95%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/switch.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
 rename arch/arm64/kvm/hyp/{ => nvhe}/timer-sr.c (84%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/tlb.c
 create mode 100644 arch/arm64/kvm/hyp/smccc_wa.S
 delete mode 100644 arch/arm64/kvm/hyp/switch.c
 delete mode 100644 arch/arm64/kvm/hyp/sysreg-sr.c
 delete mode 100644 arch/arm64/kvm/hyp/tlb.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/Makefile
 create mode 100644 arch/arm64/kvm/hyp/vhe/debug-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/switch.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/sysreg-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/timer-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/tlb.c
 delete mode 100644 arch/arm64/kvm/sys_regs_generic_v8.c

