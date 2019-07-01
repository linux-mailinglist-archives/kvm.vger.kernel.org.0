Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7DA212B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 05:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfEQD7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 23:59:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44803 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfEQD7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 23:59:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id c5so5467923wrs.11;
        Thu, 16 May 2019 20:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZuTro7RXFDzJRRmOnOZhMJCMTeb+cRd1UZrSgaGR6bo=;
        b=VhM1Vjhj0D/6WKwgTJmq564Z1Tn+tl0Nl3bcJuJhpsmRcScotGkIp6/QTup0g3x+GU
         cQTQ3jJGc5XdUiNGQmSIdzC90d6FGIVWD8aVFYPh81HkTyF7lMmOtm5fZ6ZEPB1Tu/+Y
         0alKN5wynYuePW+FzsShiW/bdnM9f2KvMR5rmJqHT9WWMVNVZHO2lINMT4gJS2WRi954
         jIeRk3CvFMpyDS5WTca5dYtoYHBjXmv8qZtGh71yeopoLYY2kZdzhhnz54ItiBnpGIry
         2J8LPw3g6dg8hT6y+6EaohNiavEPVwogHXyrEEYLJR9VRyZbC+orCahA5U4U9xd9K2B6
         LEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ZuTro7RXFDzJRRmOnOZhMJCMTeb+cRd1UZrSgaGR6bo=;
        b=bLTtagncYaYUgZxWIndJh6Hi9RQ+c8Bro9v0LS1EhXI1RjKRSJtXT+2n2R2zYC7WfW
         ondwW+9xJX5gUgdvy6MFhukWQ3gkolI5YW60Izb9mroIDWiZ3F1v4x63Qaguo7QpqS0C
         z0gEW+9zZfj+TUBooKsuMuAAwXAyIlZA9qlGpHecIOlOktXSkVUP9TEFcjK5yiKkfV65
         WXFHu/xTFEu7s23a8fqfpT7/6HMD7hz3Yyl149WRzsyu0L2dkZSjfvwKLV9cxtsMn27V
         WgTbzIFZYEjftpZWxaDOWAwi+8eawJ3prBHWg9CTM4hE5wlyAMPuUE5lhE/pWJw5nogM
         HteQ==
X-Gm-Message-State: APjAAAUeiwGYSf3KUjxt1mZ1863BCL8L7aji3Th7lU5RF6GWLtTjULJF
        4T3wWo6Vy2IjaWuUHGj6Z+Y=
X-Google-Smtp-Source: APXvYqw5UhV5ZbhvG5hCvFc8DFSsjsOWCdPUH/8fGZH//zCOUD+YM1dI2wVmEsfCJdhlA7kyIhee9Q==
X-Received: by 2002:adf:efcd:: with SMTP id i13mr4646421wrp.51.1558065581064;
        Thu, 16 May 2019 20:59:41 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v12sm6750831wrw.23.2019.05.16.20.59.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 20:59:40 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.2 merge window
Date:   Fri, 17 May 2019 05:59:36 +0200
Message-Id: <1558065576-21115-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 7a223e06b1a411cef6c4cd7a9b9a33c8d225b10e:

  KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing (2019-04-16 15:38:08 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to dd53f6102c30a774e0db8e55d49017a38060f6f6:

  Merge tag 'kvmarm-for-v5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2019-05-15 23:41:43 +0200)

----------------------------------------------------------------

* ARM: support for SVE and Pointer Authentication in guests, PMU improvements

* POWER: support for direct access to the POWER9 XIVE interrupt controller,
memory and performance optimizations.

* x86: support for accessing memory not backed by struct page, fixes and refactoring

* Generic: dirty page tracking improvements

----------------------------------------------------------------
Aaron Lewis (5):
      tests: kvm: Add tests to .gitignore
      tests: kvm: Add tests for KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_CPU_ID
      KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS state before setting new state
      tests: kvm: Add tests for KVM_SET_NESTED_STATE
      kvm: nVMX: Set nested_run_pending in vmx_set_nested_state after checks complete

Alexey Kardashevskiy (3):
      KVM: PPC: Book3S HV: Fix lockdep warning when entering the guest
      KVM: PPC: Book3S HV: Avoid lockdep debugging in TCE realmode handlers
      KVM: PPC: Book3S: Allocate guest TCEs on demand too

Amit Daniel Kachhap (3):
      KVM: arm64: Add a vcpu flag to control ptrauth for guest
      KVM: arm64: Add userspace flag to enable pointer authentication
      KVM: arm64: Add capability to advertise ptrauth for guest

Andrew Murray (9):
      arm64: arm_pmu: Remove unnecessary isb instruction
      arm64: KVM: Encapsulate kvm_cpu_context in kvm_host_data
      arm64: KVM: Add accessors to track guest/host only counters
      arm64: arm_pmu: Add !VHE support for exclude_host/exclude_guest attributes
      arm64: KVM: Enable !VHE support for :G/:H perf event modifiers
      arm64: KVM: Enable VHE support for :G/:H perf event modifiers
      arm64: KVM: Avoid isb's by using direct pmxevtyper sysreg
      arm64: docs: Document perf event attributes
      arm64: KVM: Fix perf cycle counter support for VHE

Borislav Petkov (1):
      x86/kvm: Implement HWCR support

Christian Borntraeger (9):
      KVM: s390: add vector enhancements facility 2 to cpumodel
      KVM: s390: add vector BCD enhancements facility to cpumodel
      KVM: s390: add MSA9 to cpumodel
      KVM: s390: provide query function for instructions returning 32 byte
      KVM: s390: add enhanced sort facilty to cpu model
      KVM: s390: add deflate conversion facilty to cpu model
      KVM: s390: enable MSA9 keywrapping functions depending on cpu model
      KVM: polling: add architecture backend to disable polling
      KVM: s390: provide kvm_arch_no_poll function

Colin Ian King (1):
      KVM: PPC: Book3S HV: XIVE: Fix spelling mistake "acessing" -> "accessing"

Cédric Le Goater (18):
      powerpc/xive: add OPAL extensions for the XIVE native exploitation support
      KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native exploitation mode
      KVM: PPC: Book3S HV: XIVE: Introduce a new capability KVM_CAP_PPC_IRQ_XIVE
      KVM: PPC: Book3S HV: XIVE: add a control to initialize a source
      KVM: PPC: Book3S HV: XIVE: Add a control to configure a source
      KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration
      KVM: PPC: Book3S HV: XIVE: Add a global reset control
      KVM: PPC: Book3S HV: XIVE: Add a control to sync the sources
      KVM: PPC: Book3S HV: XIVE: Add a control to dirty the XIVE EQ pages
      KVM: PPC: Book3S HV: XIVE: Add get/set accessors for the VP XIVE state
      KVM: Introduce a 'mmap' method for KVM devices
      KVM: PPC: Book3S HV: XIVE: Add a TIMA mapping
      KVM: PPC: Book3S HV: XIVE: Add a mapping for the source ESB pages
      KVM: PPC: Book3S HV: XIVE: Add passthrough support
      KVM: PPC: Book3S HV: XIVE: Activate XIVE exploitation mode
      KVM: Introduce a 'release' method for KVM devices
      KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method
      KVM: PPC: Book3S: Remove useless checks in 'release' method of KVM device

Dan Carpenter (1):
      KVM: vmx: clean up some debug output

Dave Martin (41):
      KVM: Documentation: Document arm64 core registers in detail
      arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
      KVM: arm64: Delete orphaned declaration for __fpsimd_enabled()
      KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
      KVM: arm64: Add missing #includes to kvm_host.h
      arm64/sve: Clarify role of the VQ map maintenance functions
      arm64/sve: Check SVE virtualisability
      arm64/sve: Enable SVE state tracking for non-task contexts
      KVM: arm64: Add a vcpu flag to control SVE visibility for the guest
      KVM: arm64: Propagate vcpu into read_id_reg()
      KVM: arm64: Support runtime sysreg visibility filtering
      KVM: arm64/sve: System register context switch and access support
      KVM: arm64/sve: Context switch the SVE registers
      KVM: Allow 2048-bit register access via ioctl interface
      KVM: arm64: Add missing #include of <linux/string.h> in guest.c
      KVM: arm64: Factor out core register ID enumeration
      KVM: arm64: Reject ioctl access to FPSIMD V-regs on SVE vcpus
      KVM: arm64/sve: Add SVE support to register access ioctl interface
      KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
      arm64/sve: In-kernel vector length availability query interface
      KVM: arm/arm64: Add hook for arch-specific KVM initialisation
      KVM: arm/arm64: Add KVM_ARM_VCPU_FINALIZE ioctl
      KVM: arm64/sve: Add pseudo-register for the guest's vector lengths
      KVM: arm64/sve: Allow userspace to enable SVE for vcpus
      KVM: arm64: Add a capability to advertise SVE support
      KVM: Document errors for KVM_GET_ONE_REG and KVM_SET_ONE_REG
      KVM: arm64/sve: Document KVM API extensions for SVE
      arm64/sve: Clarify vq map semantics
      KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up SVE
      KVM: arm: Make vcpu finalization stubs into inline functions
      KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to WARNs
      KVM: arm64/sve: Clean up UAPI register ID definitions
      KVM: arm64/sve: Miscellaneous tidyups in guest.c
      KVM: arm64/sve: Make register ioctl access errors more consistent
      KVM: arm64/sve: WARN when avoiding divide-by-zero in sve_reg_to_region()
      KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array sizing
      KVM: arm64/sve: Explain validity checks in set_sve_vls()
      KVM: arm/arm64: Clean up vcpu finalization function parameter naming
      KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
      KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
      KVM: arm64: Clarify access behaviour for out-of-range SVE register slice IDs

Eric Farman (1):
      KVM: s390: Fix potential spectre warnings

Filippo Sironi (1):
      X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs

Jiang Biao (1):
      kvm_main: fix some comments

Kai Huang (1):
      kvm: x86: Fix L1TF mitigation for shadow MMU

KarimAllah Ahmed (13):
      X86/nVMX: handle_vmon: Read 4 bytes from guest memory
      X86/nVMX: Update the PML table without mapping and unmapping the page
      KVM: Introduce a new guest mapping API
      X86/nVMX: handle_vmptrld: Use kvm_vcpu_map when copying VMCS12 from guest memory
      KVM/nVMX: Use kvm_vcpu_map when mapping the L1 MSR bitmap
      KVM/nVMX: Use kvm_vcpu_map when mapping the virtual APIC page
      KVM/nVMX: Use kvm_vcpu_map when mapping the posted interrupt descriptor table
      KVM/X86: Use kvm_vcpu_map in emulator_cmpxchg_emulated
      KVM/nSVM: Use the new mapping API for mapping guest memory
      KVM/nVMX: Use kvm_vcpu_map for accessing the shadow VMCS
      KVM/nVMX: Use kvm_vcpu_map for accessing the enlightened VMCS
      KVM/nVMX: Use page_address_valid in a few more locations
      kvm, x86: Properly check whether a pfn is an MMIO or not

Krish Sadhukhan (2):
      kvm: nVMX: Check "load IA32_PAT" VM-exit control on vmentry
      kvm: nVMX: Check "load IA32_PAT" VM-entry control on vmentry

Kristina Martsenko (1):
      KVM: arm64: Fix ptrauth ID register masking logic

Liran Alon (1):
      KVM: VMX: Nop emulation of MSR_IA32_POWER_CTL

Luwei Kang (2):
      KVM: x86: Inject PMI for KVM guest
      KVM: x86: Add support of clear Trace_ToPA_PMI status

Marc Zyngier (1):
      arm64: KVM: Fix system register enumeration

Mark Rutland (1):
      KVM: arm/arm64: Context-switch ptrauth registers

Michael Neuling (1):
      powerpc: Add force enable of DAWR on P9 option

Palmer Dabbelt (1):
      KVM: PPC: Book3S HV: smb->smp comment fixup

Paolo Bonzini (10):
      KVM: vmx: print more APICv fields in dump_vmcs
      KVM: x86: clear VM_EXIT_SAVE_IA32_PAT
      KVM: x86: optimize check for valid PAT value
      KVM: nVMX: Return -EINVAL when signaling failure in pre-VM-Entry helpers
      kvm: move KVM_CAP_NR_MEMSLOTS to common code
      Merge tag 'kvm-s390-next-5.2-1' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned size
      KVM: x86: use direct accessors for RIP and RSP
      Merge tag 'kvm-ppc-next-5.2-2' of git://git.kernel.org/.../paulus/powerpc into HEAD
      Merge tag 'kvmarm-for-v5.2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD

Paul Mackerras (7):
      KVM: PPC: Book3S HV: Fix XICS-on-XIVE H_IPI when priority = 0
      KVM: PPC: Book3S HV: Move HPT guest TLB flushing to C code
      KVM: PPC: Book3S HV: Flush TLB on secondary radix threads
      Merge remote-tracking branch 'remotes/powerpc/topic/ppc-kvm' into kvm-ppc-next
      KVM: PPC: Book3S HV: XIVE: Prevent races when releasing device
      KVM: PPC: Book3S HV: XIVE: Clear escalation interrupt pointers on device close
      KVM: PPC: Book3S HV: Make sure to load LPID for radix VCPUs

Peter Xu (3):
      KVM: Fix the bitmap range to copy during clear dirty
      KVM: Fix kvm_clear_dirty_log_protect off-by-(minus-)one
      KVM: Introduce KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2

Pierre Morel (2):
      KVM: s390: vsie: Do not shadow CRYCB when no AP and no keys
      KVM: s390: vsie: Return correct values for Invalid CRYCB format

Radim Krčmář (1):
      Revert "KVM: doc: Document the life cycle of a VM and its resources"

Sean Christopherson (15):
      KVM: nVMX: Move guest non-reg state checks to VM-Exit path
      KVM: nVMX: Rename and split top-level consistency checks to match SDM
      KVM: nVMX: Return -EINVAL when signaling failure in VM-Entry helpers
      KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes
      KVM: x86: Inject #GP if guest attempts to set unsupported EFER bits
      KVM: lapic: Busy wait for timer to expire when using hv_timer
      KVM: lapic: Explicitly cancel the hv timer if it's pre-expired
      KVM: lapic: Refactor ->set_hv_timer to use an explicit expired param
      KVM: lapic: Check for a pending timer intr prior to start_hv_timer()
      KVM: VMX: Skip delta_tsc shift-and-divide if the dividend is zero
      KVM: VMX: Include architectural defs header in capabilities.h
      KVM: x86: Omit caching logic for always-available GPRs
      KVM: VMX: Use accessors for GPRs outside of dedicated caching logic
      KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02 when possible
      Revert "KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU"

Suraj Jitindar Singh (4):
      KVM: PPC: Book3S HV: Implement virtual mode H_PAGE_INIT handler
      KVM: PPC: Book3S HV: Implement real mode H_PAGE_INIT handler
      KVM: PPC: Book3S HV: Handle virtual mode in XIVE VCPU push code
      KVM: PPC: Book3S HV: Save/restore vrsave register in kvmhv_p9_guest_entry()

 Documentation/arm64/perf.txt                       |   85 ++
 Documentation/arm64/pointer-authentication.txt     |   22 +-
 Documentation/powerpc/DAWR-POWER9.txt              |   32 +
 Documentation/virtual/kvm/api.txt                  |  230 +++-
 Documentation/virtual/kvm/devices/vm.txt           |    3 +-
 Documentation/virtual/kvm/devices/xive.txt         |  197 +++
 arch/arm/include/asm/kvm_emulate.h                 |    2 +
 arch/arm/include/asm/kvm_host.h                    |   26 +-
 arch/arm64/Kconfig                                 |    6 +-
 arch/arm64/include/asm/fpsimd.h                    |   29 +-
 arch/arm64/include/asm/kvm_asm.h                   |    3 +-
 arch/arm64/include/asm/kvm_emulate.h               |   16 +
 arch/arm64/include/asm/kvm_host.h                  |  101 +-
 arch/arm64/include/asm/kvm_hyp.h                   |    1 -
 arch/arm64/include/asm/kvm_ptrauth.h               |  111 ++
 arch/arm64/include/asm/sysreg.h                    |    3 +
 arch/arm64/include/uapi/asm/kvm.h                  |   43 +
 arch/arm64/kernel/asm-offsets.c                    |    7 +
 arch/arm64/kernel/cpufeature.c                     |    2 +-
 arch/arm64/kernel/fpsimd.c                         |  179 ++-
 arch/arm64/kernel/perf_event.c                     |   50 +-
 arch/arm64/kernel/signal.c                         |    5 -
 arch/arm64/kvm/Makefile                            |    2 +-
 arch/arm64/kvm/fpsimd.c                            |   17 +-
 arch/arm64/kvm/guest.c                             |  415 ++++++-
 arch/arm64/kvm/handle_exit.c                       |   36 +-
 arch/arm64/kvm/hyp/entry.S                         |   15 +
 arch/arm64/kvm/hyp/switch.c                        |   80 +-
 arch/arm64/kvm/pmu.c                               |  239 ++++
 arch/arm64/kvm/reset.c                             |  167 ++-
 arch/arm64/kvm/sys_regs.c                          |  183 ++-
 arch/arm64/kvm/sys_regs.h                          |   25 +
 arch/powerpc/include/asm/hw_breakpoint.h           |    8 +
 arch/powerpc/include/asm/kvm_host.h                |   11 +-
 arch/powerpc/include/asm/kvm_ppc.h                 |   41 +-
 arch/powerpc/include/asm/opal-api.h                |    7 +-
 arch/powerpc/include/asm/opal.h                    |    7 +
 arch/powerpc/include/asm/xive.h                    |   17 +
 arch/powerpc/include/uapi/asm/kvm.h                |   46 +
 arch/powerpc/kernel/hw_breakpoint.c                |   62 +-
 arch/powerpc/kernel/process.c                      |    9 +-
 arch/powerpc/kernel/ptrace.c                       |    3 +-
 arch/powerpc/kvm/Makefile                          |    2 +-
 arch/powerpc/kvm/book3s.c                          |   42 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |  102 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c                |  105 +-
 arch/powerpc/kvm/book3s_hv.c                       |  159 ++-
 arch/powerpc/kvm/book3s_hv_builtin.c               |   57 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |  144 +++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  109 +-
 arch/powerpc/kvm/book3s_xive.c                     |  250 +++-
 arch/powerpc/kvm/book3s_xive.h                     |   37 +
 arch/powerpc/kvm/book3s_xive_native.c              | 1249 ++++++++++++++++++++
 arch/powerpc/kvm/book3s_xive_template.c            |   78 +-
 arch/powerpc/kvm/powerpc.c                         |   40 +-
 arch/powerpc/platforms/powernv/opal-call.c         |    3 +
 arch/powerpc/sysdev/xive/native.c                  |  110 ++
 arch/s390/include/asm/cpacf.h                      |    1 +
 arch/s390/include/asm/kvm_host.h                   |    2 +
 arch/s390/include/uapi/asm/kvm.h                   |    5 +-
 arch/s390/kvm/Kconfig                              |    1 +
 arch/s390/kvm/interrupt.c                          |   11 +-
 arch/s390/kvm/kvm-s390.c                           |  120 +-
 arch/s390/kvm/vsie.c                               |   13 +-
 arch/s390/tools/gen_facilities.c                   |    3 +
 arch/x86/events/intel/core.c                       |    6 +-
 arch/x86/include/asm/e820/api.h                    |    1 +
 arch/x86/include/asm/kvm_host.h                    |    7 +-
 arch/x86/include/asm/msr-index.h                   |    8 +
 arch/x86/kernel/e820.c                             |   18 +-
 arch/x86/kvm/cpuid.c                               |   12 +-
 arch/x86/kvm/hyperv.c                              |   24 +-
 arch/x86/kvm/kvm_cache_regs.h                      |   42 +-
 arch/x86/kvm/lapic.c                               |   38 +-
 arch/x86/kvm/mmu.c                                 |   23 +-
 arch/x86/kvm/mtrr.c                                |   10 +-
 arch/x86/kvm/paging_tmpl.h                         |   38 +-
 arch/x86/kvm/svm.c                                 |  128 +-
 arch/x86/kvm/vmx/capabilities.h                    |    2 +
 arch/x86/kvm/vmx/nested.c                          |  348 +++---
 arch/x86/kvm/vmx/pmu_intel.c                       |    8 +-
 arch/x86/kvm/vmx/vmx.c                             |   90 +-
 arch/x86/kvm/vmx/vmx.h                             |   11 +-
 arch/x86/kvm/x86.c                                 |  199 ++--
 arch/x86/kvm/x86.h                                 |   10 +
 include/linux/kvm_host.h                           |   48 +
 include/linux/perf_event.h                         |    1 +
 include/uapi/linux/kvm.h                           |   15 +-
 tools/arch/s390/include/uapi/asm/kvm.h             |    3 +-
 tools/testing/selftests/kvm/.gitignore             |    7 +-
 tools/testing/selftests/kvm/Makefile               |    2 +
 tools/testing/selftests/kvm/dirty_log_test.c       |    8 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |    4 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   32 +
 .../selftests/kvm/x86_64/kvm_create_max_vcpus.c    |   70 ++
 .../kvm/x86_64/vmx_set_nested_state_test.c         |  280 +++++
 virt/kvm/Kconfig                                   |    3 +
 virt/kvm/arm/arm.c                                 |   43 +-
 virt/kvm/kvm_main.c                                |  108 +-
 99 files changed, 5838 insertions(+), 995 deletions(-)
 create mode 100644 Documentation/arm64/perf.txt
 create mode 100644 Documentation/virtual/kvm/devices/xive.txt
 create mode 100644 arch/arm64/include/asm/kvm_ptrauth.h
 create mode 100644 arch/arm64/kvm/pmu.c
 create mode 100644 arch/powerpc/kvm/book3s_xive_native.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
