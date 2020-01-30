Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58D314E0B0
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 19:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgA3SUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 13:20:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40519 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbgA3SUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 13:20:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id j104so5315680wrj.7;
        Thu, 30 Jan 2020 10:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=8gwBn7uhDjDgCnfgdECDrqw2ZvqtgNeTVvmwZMgvlPc=;
        b=vMV1q8gwB6bSdcHfKtPFTFUfa0PHxBkOH2TlebnU8E+aMu+xBo37PH8y0QU1wmRhKE
         wC7057dxmrX43polIaUeRnKD3XL6NZItwjvxVKh0twofbBk1RTC0tQ01D/hbs9LCxcP6
         KMu5qL3CEo1kbp7Pdc3kYH824af//RkZ2MzqnVz1XEYkO+zLCA/oKQ1SWE7KHT0vcR9h
         D9iF4XpFsbxTO3QWn6ipOKG9oxUFbg6092Xqj8llsIsQ8PE9Iu7cl95IJwse8otrGS7+
         Y8I1W+PlGya2AuwybLRVQVi6wHFt7wGb1ucxIdoGaUsfEKglst60M7R4RHLxwKubawk7
         LOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=8gwBn7uhDjDgCnfgdECDrqw2ZvqtgNeTVvmwZMgvlPc=;
        b=Ip96dO6hu78R9312SphsH1LeXfXCzNjp8Gxa59B+ZbpIgNB/R+su76rsKOwR8HWDqe
         ytSSJeLwto54xdLu93eMPVBgYSclS/++ef4L9nhs2n0itNXTfwCvbJxA2h17LvSSg7nF
         dmOXwdj86A3b2P7E3bzr4MGBuNqQc8Fb9w1XHbZKrW+tGyeBmBHIeQmzZFAP6ODkQHN9
         TLDYaPz6FZBNS0H9ixBFipEc5/pytX572bpwXkH3Rp16TgRFj5/c06OxEHRSmldlhcRi
         RT1RXWtraSeHRzb4OuUfoq6WTbcq5emG3xYe996eL8Afpr/+pVYkSc5g8MsrRY1XPHiX
         CmMQ==
X-Gm-Message-State: APjAAAWUB5VlF2HUlgXJHvVsrf83HMhMDLyhmGEjvbwBr8r5zw3F3+ty
        8WxA85yvgLVDCzJlT9cKerQAnYASXwI=
X-Google-Smtp-Source: APXvYqwQjatAf9f2pIqmCQOoErO3MJ2YsAknqhEbBYamBzFNclbEtjSHD0gncY0CyQe8OSAshKz+DQ==
X-Received: by 2002:a5d:46c7:: with SMTP id g7mr6824729wrs.11.1580408447325;
        Thu, 30 Jan 2020 10:20:47 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i11sm8288292wrs.10.2020.01.30.10.20.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:20:46 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for 5.6 merge window
Date:   Thu, 30 Jan 2020 19:20:42 +0100
Message-Id: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit ae6088216ce4b99b3a4aaaccd2eb2dd40d473d42:

  Merge tag 'trace-v5.5-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2020-01-06 15:38:38 -0800)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-5.6-1

for you to fetch changes up to 4cbc418a44d5067133271bb6eeac2382f2bf94f7:

  Merge branch 'cve-2019-3016' into kvm-next-5.6 (2020-01-30 18:47:59 +0100)

----------------------------------------------------------------

ARM: Cleanups and corner case fixes

PPC: Bugfixes

x86:
* Support for mapping DAX areas with large nested page table entries.
* Cleanups and bugfixes here too.  A particularly important one is
a fix for FPU load when the thread has TIF_NEED_FPU_LOAD.  There is
also a race condition which could be used in guest userspace to exploit
the guest kernel, for which the embargo expired today.
* Fast path for IPI delivery vmexits, shaving about 200 clock cycles
from IPI latency.
* Protect against "Spectre-v1/L1TF" (bring data in the cache via
speculative out of bound accesses, use L1TF on the sibling hyperthread
to read it), which unfortunately is an even bigger whack-a-mole game
than SpectreV1.

Sean continues his mission to rewrite KVM.  In addition to a sizable
number of x86 patches, this time he contributed a pretty large refactoring
of vCPU creation that affects all architectures but should not have any
visible effect.

s390 will come next week together with some more x86 patches.

----------------------------------------------------------------
Alex Shi (1):
      KVM: remove unused guest_enter

Alexandru Elisei (1):
      KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer

Andrew Jones (1):
      arm64: KVM: Add UAPI notes for swapped registers

Bharata B Rao (1):
      KVM: PPC: Book3S HV: Release lock on page-out failure path

Boris Ostrovsky (5):
      x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
      x86/kvm: Introduce kvm_(un)map_gfn()
      x86/kvm: Cache gfn to pfn translation
      x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed
      x86/KVM: Clean up host's steal time structure

Christoffer Dall (1):
      KVM: arm64: Only sign-extend MMIO up to register width

David Michael (1):
      KVM: PPC: Book3S PR: Fix -Werror=return-type build failure

Eric Auger (5):
      KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
      KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset
      KVM: arm64: pmu: Don't mark a counter as chained if the odd one is disabled
      KVM: arm64: pmu: Fix chained SW_INCR counters
      KVM: arm64: pmu: Only handle supported event counters

Gavin Shan (2):
      tools/kvm_stat: Fix kvm_exit filter name
      KVM: arm/arm64: Fix young bit from mmu notifier

Haiwei Li (1):
      Adding 'else' to reduce checking.

James Morse (3):
      KVM: arm/arm64: Re-check VMA on detecting a poisoned page
      KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests
      KVM: arm: Make inject_abt32() inject an external abort instead

Jim Mattson (3):
      kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
      kvm: nVMX: VMWRITE checks unsupported field before read-only field
      kvm: nVMX: Aesthetic cleanup of handle_vmread and handle_vmwrite

John Allen (1):
      kvm/svm: PKU not currently supported

Krish Sadhukhan (1):
      KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests

Leonardo Bras (2):
      KVM: PPC: Book3S: Replace current->mm by kvm->mm
      KVM: PPC: Book3E: Replace current->mm by kvm->mm

Marc Zyngier (1):
      KVM: arm/arm64: Cleanup MMIO handling

Marios Pomonis (13):
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L1TF attacks
      KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF attacks in x86.c
      KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect exit_reason from being used in Spectre-v1/L1TF attacks
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks
      KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks

Mark Brown (1):
      arm64: KVM: Annotate guest entry/exit as a single function

Mark Rutland (3):
      KVM: arm64: Correct PSTATE on exception entry
      KVM: arm/arm64: Correct CPSR on exception entry
      KVM: arm/arm64: Correct AArch32 SPSR on exception entry

Miaohe Lin (19):
      KVM: vmx: remove unreachable statement in vmx_get_msr_feature()
      KVM: get rid of var page in kvm_set_pfn_dirty()
      KVM: explicitly set rmap_head->val to 0 in pte_list_desc_remove_entry()
      KVM: x86: Fix some comment typos
      KVM: lib: use jump label to handle resource release in irq_bypass_register_consumer()
      KVM: lib: use jump label to handle resource release in irq_bypass_register_producer()
      KVM: x86: check kvm_pit outside kvm_vm_ioctl_reinject()
      KVM: Fix some wrong function names in comment
      KVM: Fix some out-dated function names in comment
      KVM: Fix some comment typos and missing parentheses
      KVM: Fix some grammar mistakes
      KVM: hyperv: Fix some typos in vcpu unimpl info
      KVM: Fix some writing mistakes
      KVM: vmx: delete meaningless nested_vmx_prepare_msr_bitmap() declaration
      KVM: nVMX: vmread should not set rflags to specify success in case of #PF
      KVM: x86: avoid clearing pending exception event twice
      KVM: apic: short-circuit kvm_apic_accept_pic_intr() when pic intr is accepted
      KVM: VMX: remove duplicated segment cache clear
      KVM: X86: Add 'else' to unify fastop and execute call path

Milan Pandurov (1):
      kvm: Refactor handling of VM debugfs files

Oliver Upton (1):
      KVM: nVMX: WARN on failure to set IA32_PERF_GLOBAL_CTRL

Paolo Bonzini (11):
      KVM: x86: use CPUID to locate host page table reserved bits
      KVM: x86: fix overlap between SPTE_MMIO_MASK and generation
      KVM: x86: list MSR_IA32_UCODE_REV as an emulated MSR
      KVM: async_pf: drop kvm_arch_async_page_present wrappers
      KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL
      Revert "KVM: x86: Add a WARN on TIF_NEED_FPU_LOAD in kvm_load_guest_fpu()"
      KVM: Move running VCPU from ARM to common code
      KVM: x86: inline memslot_valid_for_gpte
      Merge tag 'kvmarm-5.6' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      Merge tag 'kvm-ppc-next-5.6-2' of git://git.kernel.org/.../paulus/powerpc into HEAD
      Merge branch 'cve-2019-3016' into kvm-next-5.6

Peng Hao (1):
      kvm/x86: export kvm_vector_hashing_enabled() is unnecessary

Peter Xu (10):
      KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
      KVM: X86: Move irrelevant declarations out of ioapic.h
      KVM: X86: Use APIC_DEST_* macros properly in kvm_lapic_irq.dest_mode
      KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK
      KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros
      KVM: X86: Convert the last users of "shorthand = 0" to use macros
      KVM: Remove kvm_read_guest_atomic()
      KVM: Add build-time error check on kvm_run size
      KVM: X86: Don't take srcu lock in init_rmode_identity_map()
      KVM: X86: Drop x86_set_memory_region()

Russell King (1):
      arm64: kvm: Fix IDMAP overlap with HYP VA

Sean Christopherson (100):
      KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX platform
      KVM: x86: Add a WARN on TIF_NEED_FPU_LOAD in kvm_load_guest_fpu()
      KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM
      KVM: x86/mmu: Move definition of make_mmu_pages_available() up
      KVM: x86/mmu: Fold nonpaging_map() into nonpaging_page_fault()
      KVM: x86/mmu: Move nonpaging_page_fault() below try_async_pf()
      KVM: x86/mmu: Refactor handling of cache consistency with TDP
      KVM: x86/mmu: Refactor the per-slot level calculation in mapping_level()
      KVM: x86/mmu: Refactor handling of forced 4k pages in page faults
      KVM: x86/mmu: Incorporate guest's page level into max level for shadow MMU
      KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to max_level
      KVM: x86/mmu: Rename lpage_disallowed to account_disallowed_nx_lpage
      KVM: x86/mmu: Consolidate tdp_page_fault() and nonpaging_page_fault()
      KVM: x86/mmu: Move transparent_hugepage_adjust() above __direct_map()
      KVM: x86/mmu: Move calls to thp_adjust() down a level
      KVM: x86/mmu: Move root_hpa validity checks to top of page fault handler
      KVM: x86/mmu: WARN on an invalid root_hpa
      KVM: x86/mmu: WARN if root_hpa is invalid when handling a page fault
      KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
      KVM: VMX: Add helper to consolidate up PT/RTIT WRMSR fault logic
      KVM: x86: Don't let userspace set host-reserved cr4 bits
      KVM: x86: Ensure all logical CPUs have consistent reserved cr4 bits
      KVM: x86: Drop special XSAVE handling from guest_cpuid_has()
      KVM: x86: Add macro to ensure reserved cr4 bits checks stay in sync
      KVM: x86: Add dedicated emulator helpers for querying CPUID features
      KVM: x86: Move bit() helper to cpuid.h
      KVM: x86: Add CPUID_7_1_EAX to the reverse CPUID table
      KVM: x86: Expand build-time assertion on reverse CPUID usage
      KVM: x86: Refactor and rename bit() to feature_bit() macro
      KVM: x86/mmu: Reorder the reserved bit check in prefetch_invalid_gpte()
      KVM: x86/mmu: Micro-optimize nEPT's bad memptype/XWR checks
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
      KVM: VMX: Allocate VPID after initializing VCPU
      KVM: VMX: Use direct vcpu pointer during vCPU create/free
      KVM: SVM: Use direct vcpu pointer during vCPU create/free
      KVM: x86: Allocate vcpu struct in common x86 code
      KVM: x86: Move FPU allocation to common x86 code
      KVM: x86: Move allocation of pio_data page down a few lines
      KVM: x86: Move kvm_vcpu_init() invocation to common code
      KVM: PPC: e500mc: Add build-time assert that vcpu is at offset 0
      KVM: PPC: Allocate vcpu struct in common PPC code
      KVM: PPC: Book3S PR: Allocate book3s and shadow vcpu after common init
      KVM: PPC: e500mc: Move reset of oldpir below call to kvm_vcpu_init()
      KVM: PPC: Move kvm_vcpu_init() invocation to common code
      KVM: MIPS: Use kvm_vcpu_cache to allocate vCPUs
      KVM: MIPS: Drop kvm_arch_vcpu_free()
      KVM: PPC: Drop kvm_arch_vcpu_free()
      KVM: arm: Drop kvm_arch_vcpu_free()
      KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path
      KVM: x86: Remove spurious clearing of async #PF MSR
      KVM: x86: Drop kvm_arch_vcpu_free()
      KVM: Remove kvm_arch_vcpu_free() declaration
      KVM: Add kvm_arch_vcpu_precreate() to handle pre-allocation issues
      KVM: s390: Move guts of kvm_arch_vcpu_init() into kvm_arch_vcpu_create()
      KVM: s390: Invoke kvm_vcpu_init() before allocating sie_page
      KVM: MIPS: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
      KVM: x86: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
      KVM: Introduce kvm_vcpu_destroy()
      KVM: Move vcpu alloc and init invocation to common code
      KVM: Unexport kvm_vcpu_cache and kvm_vcpu_{un}init()
      KVM: Move initialization of preempt notifier to kvm_vcpu_init()
      KVM: x86: Move guts of kvm_arch_vcpu_setup() into kvm_arch_vcpu_create()
      KVM: MIPS: Move .vcpu_setup() call to kvm_arch_vcpu_create()
      KVM: s390: Manually invoke vcpu setup during kvm_arch_vcpu_create()
      KVM: PPC: BookE: Setup vcpu during kvmppc_core_vcpu_create()
      KVM: Drop kvm_arch_vcpu_setup()
      KVM: x86: Move all vcpu init code into kvm_arch_vcpu_create()
      KVM: MIPS: Move all vcpu init code into kvm_arch_vcpu_create()
      KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()
      KVM: PPC: Move all vcpu init code into kvm_arch_vcpu_create()
      KVM: arm64: Free sve_state via arm specific hook
      KVM: Drop kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit()
      KVM: Move putting of vcpu->pid to kvm_vcpu_destroy()
      KVM: Move vcpu->run page allocation out of kvm_vcpu_init()
      KVM: x86: Handle TIF_NEED_FPU_LOAD in kvm_{load,put}_guest_fpu()
      KVM: x86: Ensure guest's FPU state is loaded when accessing for emulation
      KVM: x86: Revert "KVM: X86: Fix fpu state crash in kvm guest"
      KVM: x86: Remove unused ctxt param from emulator's FPU accessors
      KVM: x86: Perform non-canonical checks in 32-bit KVM
      KVM: Check for a bad hva before dropping into the ghc slow path
      KVM: Clean up __kvm_gfn_to_hva_cache_init() and its callers
      KVM: Return immediately if __kvm_gfn_to_hva_cache_init() fails
      KVM: x86/mmu: Enforce max_level on HugeTLB mappings
      mm: thp: KVM: Explicitly check for THP when populating secondary MMU
      KVM: Use vcpu-specific gva->hva translation when querying host page size
      KVM: Play nice with read-only memslots when querying host page size
      x86/mm: Introduce lookup_address_in_mm()
      KVM: x86/mmu: Refactor THP adjust to prep for changing query
      KVM: x86/mmu: Walk host page tables to find THP mappings
      KVM: x86/mmu: Drop level optimization from fast_page_fault()
      KVM: x86/mmu: Rely on host page tables to find HugeTLB mappings
      KVM: x86/mmu: Remove obsolete gfn restoration in FNAME(fetch)
      KVM: x86/mmu: Zap any compound page when collapsing sptes
      KVM: x86/mmu: Fold max_mapping_level() into kvm_mmu_hugepage_adjust()
      KVM: x86/mmu: Remove lpage_is_disallowed() check from set_spte()
      KVM: x86/mmu: Use huge pages for DAX-backed files
      KVM: x86: Use a typedef for fastop functions

Shannon Zhao (1):
      KVM: ARM: Call hyp_cpu_pm_exit at the right place

Sukadev Bhattiprolu (2):
      KVM: PPC: Add skip_page_out parameter to uvmem functions
      KVM: PPC: Book3S HV: Implement H_SVM_INIT_ABORT hcall

Tom Lendacky (1):
      KVM: SVM: Override default MMIO mask if memory encryption is enabled

Vitaly Kuznetsov (1):
      x86/kvm/hyper-v: remove stale evmcs_already_enabled check from nested_enable_evmcs()

Wanpeng Li (2):
      KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
      KVM: LAPIC: micro-optimize fixed mode ipi delivery

Xiaoyao Li (3):
      KVM: VMX: Rename INTERRUPT_PENDING to INTERRUPT_WINDOW
      KVM: VMX: Rename NMI_PENDING to NMI_WINDOW
      KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING

YueHaibing (1):
      KVM: arm: Remove duplicate include

Zenghui Yu (4):
      KVM: Remove duplicated declaration of kvm_vcpu_kick
      KVM: arm/arm64: vgic: Handle GICR_PENDBASER.PTZ filed as RAZ
      KVM: arm/arm64: vgic-its: Properly check the unmapped coll in DISCARD handler
      KVM: arm/arm64: vgic: Drop the kvm_vgic_register_mmio_region()

zhengbin (1):
      KVM: PPC: Remove set but not used variable 'ra', 'rs', 'rt'

 Documentation/powerpc/ultravisor.rst               |  60 ++
 Documentation/virt/kvm/api.txt                     |   9 +
 arch/arm/include/asm/kvm_emulate.h                 |  27 +-
 arch/arm/include/asm/kvm_host.h                    |  16 +-
 arch/arm/include/asm/kvm_hyp.h                     |   1 +
 arch/arm/include/asm/kvm_mmio.h                    |  26 -
 arch/arm/kvm/guest.c                               |   5 -
 arch/arm64/include/asm/kvm_emulate.h               |  40 +-
 arch/arm64/include/asm/kvm_host.h                  |  16 +-
 arch/arm64/include/asm/kvm_mmio.h                  |  29 -
 arch/arm64/include/asm/ptrace.h                    |   1 +
 arch/arm64/include/uapi/asm/kvm.h                  |  12 +-
 arch/arm64/include/uapi/asm/ptrace.h               |   1 +
 arch/arm64/kvm/guest.c                             |   5 -
 arch/arm64/kvm/hyp/entry.S                         |   7 +-
 arch/arm64/kvm/inject_fault.c                      |  70 ++-
 arch/arm64/kvm/reset.c                             |   2 +-
 arch/arm64/kvm/va_layout.c                         |  56 +-
 arch/mips/kvm/mips.c                               |  84 +--
 arch/powerpc/include/asm/hvcall.h                  |   1 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h        |  10 +-
 arch/powerpc/include/asm/kvm_host.h                |   1 +
 arch/powerpc/include/asm/kvm_ppc.h                 |   5 +-
 arch/powerpc/kvm/book3s.c                          |   9 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   2 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |  10 +-
 arch/powerpc/kvm/book3s_hv.c                       |  42 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |  34 +-
 arch/powerpc/kvm/book3s_pr.c                       |  34 +-
 arch/powerpc/kvm/book3s_xive_native.c              |   2 +-
 arch/powerpc/kvm/booke.c                           |  67 +--
 arch/powerpc/kvm/e500.c                            |  36 +-
 arch/powerpc/kvm/e500mc.c                          |  30 +-
 arch/powerpc/kvm/emulate_loadstore.c               |   5 -
 arch/powerpc/kvm/powerpc.c                         |  88 +--
 arch/s390/include/asm/kvm_host.h                   |   1 -
 arch/s390/kvm/kvm-s390.c                           | 118 ++--
 arch/x86/include/asm/kvm_emulate.h                 |   4 +
 arch/x86/include/asm/kvm_host.h                    |  34 +-
 arch/x86/include/asm/pgtable_types.h               |   4 +
 arch/x86/include/asm/vmx.h                         |   6 +-
 arch/x86/include/uapi/asm/vmx.h                    |   4 +-
 arch/x86/kvm/cpuid.c                               |   9 +-
 arch/x86/kvm/cpuid.h                               |  45 +-
 arch/x86/kvm/emulate.c                             | 133 +++--
 arch/x86/kvm/hyperv.c                              |  17 +-
 arch/x86/kvm/i8259.c                               |   6 +-
 arch/x86/kvm/ioapic.c                              |  41 +-
 arch/x86/kvm/ioapic.h                              |   6 -
 arch/x86/kvm/irq.h                                 |   3 +
 arch/x86/kvm/irq_comm.c                            |  18 +-
 arch/x86/kvm/lapic.c                               |  37 +-
 arch/x86/kvm/lapic.h                               |   9 +-
 arch/x86/kvm/mmu/mmu.c                             | 605 +++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h                     |  88 +--
 arch/x86/kvm/mmutrace.h                            |  12 +-
 arch/x86/kvm/mtrr.c                                |   8 +-
 arch/x86/kvm/pmu.h                                 |  18 +-
 arch/x86/kvm/svm.c                                 | 134 +++--
 arch/x86/kvm/vmx/capabilities.h                    |   5 +
 arch/x86/kvm/vmx/evmcs.c                           |   5 -
 arch/x86/kvm/vmx/nested.c                          | 189 +++----
 arch/x86/kvm/vmx/pmu_intel.c                       |  24 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h              |   4 +-
 arch/x86/kvm/vmx/vmx.c                             | 294 +++++-----
 arch/x86/kvm/x86.c                                 | 569 +++++++++++--------
 arch/x86/kvm/x86.h                                 |  23 +-
 arch/x86/mm/pageattr.c                             |  11 +
 include/linux/context_tracking.h                   |   9 -
 include/linux/huge_mm.h                            |   6 +
 include/linux/kvm_host.h                           |  40 +-
 include/linux/kvm_types.h                          |   9 +-
 mm/huge_memory.c                                   |  11 +
 tools/arch/x86/include/uapi/asm/vmx.h              |   4 +-
 tools/kvm/kvm_stat/kvm_stat                        |   8 +-
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |   8 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |   2 +-
 virt/kvm/arm/aarch32.c                             | 131 ++++-
 virt/kvm/arm/arch_timer.c                          |   5 +-
 virt/kvm/arm/arm.c                                 | 113 +---
 virt/kvm/arm/mmio.c                                |  68 +--
 virt/kvm/arm/mmu.c                                 |  32 +-
 virt/kvm/arm/perf.c                                |   6 +-
 virt/kvm/arm/pmu.c                                 | 114 ++--
 virt/kvm/arm/vgic/vgic-its.c                       |   6 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |   5 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |  15 +-
 virt/kvm/arm/vgic/vgic-mmio.h                      |   5 -
 virt/kvm/async_pf.c                                |  31 +-
 virt/kvm/kvm_main.c                                | 435 +++++++++------
 virt/lib/irqbypass.c                               |  38 +-
 92 files changed, 2387 insertions(+), 2045 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_mmio.h
 delete mode 100644 arch/arm64/include/asm/kvm_mmio.h
